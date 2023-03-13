/**
 * The app navigator (formerly "AppNavigator" and "MainNavigator") is used for the primary
 * navigation flows of your app.
 * Generally speaking, it will contain an auth flow (registration, login, forgot password)
 * and a "main" flow which the user will use once logged in.
 */
import {
  DarkTheme,
  DefaultTheme,
  NavigationContainer,
} from "@react-navigation/native"
import { createMaterialBottomTabNavigator, MaterialBottomTabScreenProps } from "@react-navigation/material-bottom-tabs"
import { observer } from "mobx-react-lite"
import React from "react"
import { useColorScheme } from "react-native"
import Config from "../config"
import {
  WelcomeScreen, AboutScreen, PlaygroundScreen,
} from "../screens"
import { navigationRef, useBackButtonHandler } from "./navigationUtilities"
import MaterialCommunityIcons from 'react-native-vector-icons/MaterialCommunityIcons'

/**
 * This type allows TypeScript to know what routes are defined in this navigator
 * as well as what properties (if any) they might take when navigating to them.
 *
 * If no params are allowed, pass through `undefined`. Generally speaking, we
 * recommend using your MobX-State-Tree store(s) to keep application state
 * rather than passing state through navigation params.
 *
 * For more information, see this documentation:
 *   https://reactnavigation.org/docs/params/
 *   https://reactnavigation.org/docs/typescript#type-checking-the-navigator
 *   https://reactnavigation.org/docs/typescript/#organizing-types
 */
export type NavigatorParamList = {
  Welcome: undefined,
  About: undefined,
  Playground: undefined,
  // 🔥 Your screens go here
}

const Tab = createMaterialBottomTabNavigator<NavigatorParamList>()

export type BaseScreenProps<T extends keyof NavigatorParamList> = MaterialBottomTabScreenProps<NavigatorParamList, T>

function AppTabs() {
  const iconSize = 24
  return (
    <Tab.Navigator
      initialRouteName="Welcome">
      <Tab.Screen
        name="Welcome"
        component={WelcomeScreen}
        options={{
          title: "Home",
          tabBarIcon: icon('home', 'home-outline'),
        }}
      />
      <Tab.Screen
        name="About"
        component={AboutScreen}
        options={{
          title: "About",
          tabBarIcon: icon('information', 'information-outline'),
        }}
      />
      <Tab.Screen
        name="Playground"
        component={PlaygroundScreen}
        options={{
          title: "Playground",
          tabBarIcon: icon('kite', 'kite-outline'),
        }}
      />
    </Tab.Navigator>
  );

  function icon(focusedIcon: string, unfocusedIcon: string) {
    return ({ color, focused }) => (
      <MaterialCommunityIcons
        name={focused ? focusedIcon : unfocusedIcon}
        color={color}
        size={iconSize} />
    )
  }
}

/**
 * This is a list of all the route names that will exit the app if the back button
 * is pressed while in that screen. Only affects Android.
 */
const exitRoutes = Config.exitRoutes

interface NavigationProps extends Partial<React.ComponentProps<typeof NavigationContainer>> { }

export const AppNavigator = observer(function AppNavigator(props: NavigationProps) {
  const colorScheme = useColorScheme()

  useBackButtonHandler((routeName) => exitRoutes.includes(routeName))

  return (
    <NavigationContainer
      ref={navigationRef}
      theme={colorScheme === "dark" ? DarkTheme : DefaultTheme}
      {...props}
    >
      <AppTabs />
    </NavigationContainer>
  )
})
