package sweet_build_command

import (
	"fmt"
	"io"

	"github.com/google/blueprint"

	"android/soong/android"
)

var (
	moduleName = "sweet_build_command"
	pctx       = android.NewPackageContext("android/soong/" + moduleName)
)

func init() {
	android.InitRegistrationContext.RegisterModuleType(moduleName, SweetBuildCommandFactory)
}

type moduleProperties struct {
	Cmd      string
	Required []string
}

type Module struct {
	android.ModuleBase
	properties moduleProperties
	outputPath android.WritablePath
}

func (g *Module) GenerateAndroidBuildActions(ctx android.ModuleContext) {
	g.outputPath = android.PathForModuleGen(ctx)

	if len(g.properties.Cmd) == 0 {
		ctx.ModuleErrorf("%s", "missing property 'cmd'")
		return
	}

	command, err := android.ExpandNinjaEscaped(g.properties.Cmd, func(name string) (string, bool, error) {
		switch name {
		case "productOut":
			return ctx.Config().Getenv("OUT_DIR") + "/target/product/" + ctx.Config().DeviceName(), false, nil
		default:
			return "", false, fmt.Errorf("unknown variable '%s'", name)
		}
	})

	if err == nil {
		g.runCommand(ctx, command)
	} else {
		ctx.PropertyErrorf("cmd", "%s", err.Error())
	}
}

func (g *Module) runCommand(ctx android.ModuleContext, command string) {
	ruleParams := blueprint.RuleParams{
		Command:     command,
		CommandDeps: g.properties.Required,
	}
	rule := ctx.Rule(pctx, moduleName, ruleParams, nil...)
	params := android.BuildParams{
		Rule:        rule,
		Description: " ",
		Output:      g.outputPath,
	}

	ctx.Build(pctx, params)
}

func (g *Module) AndroidMk() android.AndroidMkData {
	return android.AndroidMkData{
		Include:    "$(BUILD_PHONY_PACKAGE)",
		OutputFile: android.OptionalPathForPath(g.outputPath),
		Extra: []android.AndroidMkExtraFunc{
			func(w io.Writer, output android.Path) {
				fmt.Fprintln(w, "LOCAL_ADDITIONAL_DEPENDENCIES := ", g.outputPath.String())
			},
		},
	}
}

func SweetBuildCommandFactory() android.Module {
	module := &Module{}
	module.AddProperties(&module.properties)
	android.InitAndroidModule(module)
	return module
}
