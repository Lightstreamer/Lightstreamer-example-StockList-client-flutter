//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <lightstreamer_flutter_client/lightstreamer_flutter_client_plugin_c_api.h>
#include <url_launcher_windows/url_launcher_windows.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  LightstreamerFlutterClientPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("LightstreamerFlutterClientPluginCApi"));
  UrlLauncherWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("UrlLauncherWindows"));
}
