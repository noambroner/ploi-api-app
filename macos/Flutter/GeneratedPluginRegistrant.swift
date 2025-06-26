//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import package_info_plus
import path_provider_foundation
import protocol_handler_macos
import screen_retriever_macos
import shared_preferences_foundation
import sqflite_darwin
import tray_manager
import url_launcher_macos
import window_manager

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  FPPPackageInfoPlusPlugin.register(with: registry.registrar(forPlugin: "FPPPackageInfoPlusPlugin"))
  PathProviderPlugin.register(with: registry.registrar(forPlugin: "PathProviderPlugin"))
  ProtocolHandlerMacosPlugin.register(with: registry.registrar(forPlugin: "ProtocolHandlerMacosPlugin"))
  ScreenRetrieverMacosPlugin.register(with: registry.registrar(forPlugin: "ScreenRetrieverMacosPlugin"))
  SharedPreferencesPlugin.register(with: registry.registrar(forPlugin: "SharedPreferencesPlugin"))
  SqflitePlugin.register(with: registry.registrar(forPlugin: "SqflitePlugin"))
  TrayManagerPlugin.register(with: registry.registrar(forPlugin: "TrayManagerPlugin"))
  UrlLauncherPlugin.register(with: registry.registrar(forPlugin: "UrlLauncherPlugin"))
  WindowManagerPlugin.register(with: registry.registrar(forPlugin: "WindowManagerPlugin"))
}
