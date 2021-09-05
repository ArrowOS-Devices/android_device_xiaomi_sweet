// Copyright 2015 Google Inc. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package gencmd

import (
	"fmt"
    "io"
    "strings"

	"github.com/google/blueprint"
	"github.com/google/blueprint/proptools"

	"android/soong/android"
)

func init() {
	registerGenruleBuildComponents(android.InitRegistrationContext)
}

func registerGenruleBuildComponents(ctx android.RegistrationContext) {
	ctx.RegisterModuleType("gencmd", GenRuleFactory)
}

var (
	pctx = android.NewPackageContext("android/soong/gencmd")
)

func init() {
	pctx.Import("android/soong/android")
}

type SourceFileGenerator interface {
	GeneratedSourceFiles() android.Paths
	GeneratedDeps() android.Paths
}

type HostToolProvider interface {
	android.HostToolProvider
}

type hostToolDependencyTag struct {
	blueprint.BaseDependencyTag
	label string
}

type generatorProperties struct {
	Cmd *string
    Required []string
}

type Module struct {
	android.ModuleBase
	android.DefaultableModuleBase
	android.ApexModuleBase

	Extra interface{}

	properties generatorProperties

	taskGenerator taskFunc

	rule        blueprint.Rule

	outputFiles android.Paths
	outputDeps  android.Paths

	subName string
}

type taskFunc func(ctx android.ModuleContext, rawCommand string) []generateTask

type generateTask struct {
	out    android.ModuleGenPath
	cmd    string
}

func (g *Module) GeneratedSourceFiles() android.Paths {
	return g.outputFiles
}

func (g *Module) GeneratedDeps() android.Paths {
	return g.outputDeps
}

func (g *Module) GenerateAndroidBuildActions(ctx android.ModuleContext) {
	g.subName = ctx.ModuleSubDir()

	if ctx.Failed() {
		return
	}

	var outputFiles android.WritablePaths

	for _, task := range g.taskGenerator(ctx, String(g.properties.Cmd)) {
		rawCommand, err := android.ExpandNinjaEscaped(task.cmd, func(name string) (string, bool, error) {
			reportError := func(fmt string, args ...interface{}) (string, bool, error) {
				ctx.PropertyErrorf("cmd", fmt, args...)
				return "SOONG_ERROR", false, nil
			}

			switch name {
			case "deviceOut":
				return "out/target/product/" + ctx.Config().DeviceName(), false, nil
			default:
				return reportError("unknown variable '$(%s)'", name)
			}
		})

		if err != nil {
			ctx.PropertyErrorf("cmd", "%s", err.Error())
			return
		}

		rawCommand = rawCommand + "; rm -rf " + fmt.Sprintf("%v", task.out)
		ruleParams := blueprint.RuleParams{
			Command: rawCommand,
            CommandDeps: g.properties.Required,
		}

		name := "gencmd"
		rule := ctx.Rule(pctx, name, ruleParams, nil...)

		g.generateSourceFile(ctx, task, rule)
		outputFiles = append(outputFiles, task.out)
	}

	g.outputFiles = outputFiles.Paths()

	phonyFile := android.PathForModuleGen(ctx, "gencmd-phony")

	ctx.Build(pctx, android.BuildParams{
		Rule:   blueprint.Phony,
		Output: phonyFile,
		Inputs: g.outputFiles,
	})

	g.outputDeps = android.Paths{phonyFile}
}

func (g *Module) generateSourceFile(ctx android.ModuleContext, task generateTask, rule blueprint.Rule) {
	desc := "execute"

	params := android.BuildParams{
		Rule:            rule,
		Description:     desc,
		Output:          task.out,
	}

	ctx.Build(pctx, params)
}

func (g *Module) AndroidMk() android.AndroidMkData {
	return android.AndroidMkData{
		Include:    "$(BUILD_PHONY_PACKAGE)",
		Class:      "FAKE",
		OutputFile: android.OptionalPathForPath(g.outputFiles[0]),
		SubName:    g.subName,
		Extra: []android.AndroidMkExtraFunc{
			func(w io.Writer, outputFile android.Path) {
				fmt.Fprintln(w, "LOCAL_ADDITIONAL_DEPENDENCIES :=", strings.Join(g.outputDeps.Strings(), " "))
			},
		},
		Custom: func(w io.Writer, name, prefix, moduleDir string, data android.AndroidMkData) {
			android.WriteAndroidMkData(w, data)
			if data.SubName != "" {
				fmt.Fprintln(w, ".PHONY:", name)
				fmt.Fprintln(w, name, ":", name+g.subName)
			}
		},
	}
}

func generatorFactory(taskGenerator taskFunc, props ...interface{}) *Module {
	module := &Module{
		taskGenerator: taskGenerator,
	}

	module.AddProperties(props...)
	module.AddProperties(&module.properties)

	return module
}

func NewGenRule() *Module {
	properties := &genRuleProperties{}

	taskGenerator := func(ctx android.ModuleContext, rawCommand string) []generateTask {
		return []generateTask{{
			out:    android.PathForModuleGen(ctx),
			cmd:    rawCommand,
		}}
	}

	return generatorFactory(taskGenerator, properties)
}

func GenRuleFactory() android.Module {
	m := NewGenRule()
	android.InitAndroidModule(m)
	android.InitDefaultableModule(m)
	return m
}

type genRuleProperties struct {
	Out []string `android:"arch_variant"`
}

var Bool = proptools.Bool
var String = proptools.String
