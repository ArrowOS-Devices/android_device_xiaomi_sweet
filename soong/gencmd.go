package gencmd

import (
	"fmt"
	"io"
	"path/filepath"

	"github.com/google/blueprint"

	"android/soong/android"
)

var (
	moduleName = "gencmd"
	pctx       = android.NewPackageContext("android/soong/" + moduleName)
)

func init() {
	android.InitRegistrationContext.RegisterModuleType(moduleName, GenRuleFactory)
}

type generatorProperties struct {
	Cmd      *string
	Required []string
}

type Module struct {
	android.ModuleBase
	properties generatorProperties

	outputFile android.WritablePath
}

func (g *Module) GenerateAndroidBuildActions(ctx android.ModuleContext) {
    g.outputFile = android.PathForModuleGen(ctx)

	rawCommand, err := android.ExpandNinjaEscaped(*g.properties.Cmd, func(name string) (string, bool, error) {
		switch name {
		case "productOut":
			return filepath.Join(ctx.Config().BuildDir(), "/../", "target", "product") + "/" + ctx.Config().DeviceName(), false, nil
		default:
			return "", false, nil
		}
	})

	if err != nil {
		ctx.PropertyErrorf("cmd", "%s", err.Error())
		return
	}

	command := fmt.Sprintf("rm -rf %v; %s", g.outputFile, rawCommand)
	ruleParams := blueprint.RuleParams{
		Command:     command,
		CommandDeps: g.properties.Required,
	}
	rule := ctx.Rule(pctx, moduleName, ruleParams, nil...)
	g.runCommand(ctx, g.outputFile, rule)
}

func (g *Module) runCommand(ctx android.ModuleContext, out android.WritablePath, rule blueprint.Rule) {
	params := android.BuildParams{
		Rule:        rule,
		Output:      out,
	}

	ctx.Build(pctx, params)
}

func (g *Module) AndroidMk() android.AndroidMkData {
	return android.AndroidMkData{
		Include:    "$(BUILD_PHONY_PACKAGE)",
		OutputFile: android.OptionalPathForPath(g.outputFile),
		Extra: []android.AndroidMkExtraFunc{
			func(w io.Writer, outputFile android.Path) {
				fmt.Fprintln(w, "LOCAL_ADDITIONAL_DEPENDENCIES :=", g.outputFile.String())
			},
		},
	}
}

func NewGenRule() *Module {
	module := &Module{}
	module.AddProperties(&module.properties)

	return module
}

func GenRuleFactory() android.Module {
	m := NewGenRule()
	android.InitAndroidModule(m)
	return m
}
