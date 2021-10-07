package sweet_build_command

import (
	"fmt"
	"io"

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
	command    string
}

func (g *Module) GenerateAndroidBuildActions(ctx android.ModuleContext) {
	productOut := ctx.Config().Getenv("OUT_DIR") + "/target/product/" + ctx.Config().DeviceName()
	g.outputPath = android.PathForModuleGen(ctx)

	if len(g.properties.Cmd) == 0 {
		ctx.ModuleErrorf("%s", "missing property 'cmd'")
		return
	}

	command, err := android.ExpandNinjaEscaped(g.properties.Cmd, func(name string) (string, bool, error) {
		switch name {
		case "productOut":
			return productOut, false, nil
		default:
			return "", false, fmt.Errorf("unknown variable '%s'", name)
		}
	})

	if err == nil {
		g.command = fmt.Sprintf("(%s); rm -f %s/system/etc/%s", command, productOut, g.Name())
	} else {
		ctx.PropertyErrorf("cmd", "%s", err.Error())
	}
}

func (g *Module) AndroidMk() android.AndroidMkData {
	return android.AndroidMkData{
		Include:    "$(BUILD_PREBUILT)",
		OutputFile: android.OptionalPathForPath(g.outputPath),
		Extra: []android.AndroidMkExtraFunc{
			func(w io.Writer, output android.Path) {
				fmt.Fprintln(w, "LOCAL_MODULE := ", g.Name())
				fmt.Fprintln(w, "LOCAL_PREBUILT_MODULE_FILE := /dev/null")
				fmt.Fprintln(w, "LOCAL_MODULE_CLASS := ETC")
				fmt.Fprintln(w, "LOCAL_POST_INSTALL_CMD := ", g.command)
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
