import { adaptNavigationTheme, MD3DarkTheme, MD3LightTheme, useTheme } from "react-native-paper"
import { DarkTheme as NavigationDarkTheme, DefaultTheme as NavigationDefaultTheme } from "@react-navigation/native"
import merge from "deepmerge"
import { useColorScheme } from "react-native"

const colorsLight = {
  "primary": "rgb(121, 89, 0)",
  "onPrimary": "rgb(255, 255, 255)",
  "primaryContainer": "rgb(255, 222, 160)",
  "onPrimaryContainer": "rgb(38, 25, 0)",
  "secondary": "rgb(108, 92, 63)",
  "onSecondary": "rgb(255, 255, 255)",
  "secondaryContainer": "rgb(245, 224, 187)",
  "onSecondaryContainer": "rgb(36, 26, 4)",
  "tertiary": "rgb(75, 101, 70)",
  "onTertiary": "rgb(255, 255, 255)",
  "tertiaryContainer": "rgb(204, 235, 195)",
  "onTertiaryContainer": "rgb(8, 32, 8)",
  "error": "rgb(186, 26, 26)",
  "onError": "rgb(255, 255, 255)",
  "errorContainer": "rgb(255, 218, 214)",
  "onErrorContainer": "rgb(65, 0, 2)",
  "background": "rgb(255, 251, 255)",
  "onBackground": "rgb(30, 27, 22)",
  "surface": "rgb(255, 251, 255)",
  "onSurface": "rgb(30, 27, 22)",
  "surfaceVariant": "rgb(237, 225, 207)",
  "onSurfaceVariant": "rgb(77, 70, 57)",
  "outline": "rgb(127, 118, 103)",
  "outlineVariant": "rgb(208, 197, 180)",
  "shadow": "rgb(0, 0, 0)",
  "scrim": "rgb(0, 0, 0)",
  "inverseSurface": "rgb(52, 48, 42)",
  "inverseOnSurface": "rgb(248, 239, 231)",
  "inversePrimary": "rgb(246, 190, 59)",
  "elevation": {
    "level0": "transparent",
    "level1": "rgb(248, 243, 242)",
    "level2": "rgb(244, 238, 235)",
    "level3": "rgb(240, 233, 227)",
    "level4": "rgb(239, 232, 224)",
    "level5": "rgb(236, 228, 219)",
  },
  "surfaceDisabled": "rgba(30, 27, 22, 0.12)",
  "onSurfaceDisabled": "rgba(30, 27, 22, 0.38)",
  "backdrop": "rgba(54, 48, 36, 0.4)",
}

const colorsDark = {
  "primary": "rgb(246, 190, 59)",
  "onPrimary": "rgb(64, 45, 0)",
  "primaryContainer": "rgb(92, 67, 0)",
  "onPrimaryContainer": "rgb(255, 222, 160)",
  "secondary": "rgb(216, 196, 160)",
  "onSecondary": "rgb(59, 47, 21)",
  "secondaryContainer": "rgb(83, 69, 42)",
  "onSecondaryContainer": "rgb(245, 224, 187)",
  "tertiary": "rgb(177, 207, 169)",
  "onTertiary": "rgb(30, 54, 27)",
  "tertiaryContainer": "rgb(52, 77, 48)",
  "onTertiaryContainer": "rgb(204, 235, 195)",
  "error": "rgb(255, 180, 171)",
  "onError": "rgb(105, 0, 5)",
  "errorContainer": "rgb(147, 0, 10)",
  "onErrorContainer": "rgb(255, 180, 171)",
  "background": "rgb(30, 27, 22)",
  "onBackground": "rgb(233, 225, 216)",
  "surface": "rgb(30, 27, 22)",
  "onSurface": "rgb(233, 225, 216)",
  "surfaceVariant": "rgb(77, 70, 57)",
  "onSurfaceVariant": "rgb(208, 197, 180)",
  "outline": "rgb(153, 143, 128)",
  "outlineVariant": "rgb(77, 70, 57)",
  "shadow": "rgb(0, 0, 0)",
  "scrim": "rgb(0, 0, 0)",
  "inverseSurface": "rgb(233, 225, 216)",
  "inverseOnSurface": "rgb(52, 48, 42)",
  "inversePrimary": "rgb(121, 89, 0)",
  "elevation": {
    "level0": "transparent",
    "level1": "rgb(41, 35, 24)",
    "level2": "rgb(47, 40, 25)",
    "level3": "rgb(54, 45, 26)",
    "level4": "rgb(56, 47, 26)",
    "level5": "rgb(60, 50, 27)",
  },
  "surfaceDisabled": "rgba(233, 225, 216, 0.12)",
  "onSurfaceDisabled": "rgba(233, 225, 216, 0.38)",
  "backdrop": "rgba(54, 48, 36, 0.4)",
}

const materialLightTheme = {
  ...MD3LightTheme,
  colors: colorsLight,
}

const materialDarkTheme = {
  ...MD3DarkTheme,
  colors: colorsDark,
}

const { LightTheme, DarkTheme } = adaptNavigationTheme({
  reactNavigationLight: NavigationDefaultTheme,
  reactNavigationDark: NavigationDarkTheme,
  materialDark: materialDarkTheme,
  materialLight: materialLightTheme,
})

export const AppDefaultTheme = merge(materialLightTheme, LightTheme)
export const AppDarkTheme = merge(materialDarkTheme, DarkTheme)

export function appTheme(): AppTheme {
  const colorScheme = useColorScheme()
  return colorScheme === "dark" ? AppDarkTheme : AppDefaultTheme
}

export type AppTheme = typeof AppDefaultTheme & typeof AppDarkTheme
export const useAppTheme = () => useTheme<AppTheme>()
