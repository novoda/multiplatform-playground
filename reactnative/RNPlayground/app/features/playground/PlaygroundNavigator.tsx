import * as React from "react"
import { BaseScreenProps, NavigatorParamList } from "../../navigators"
import { createNativeStackNavigator } from "@react-navigation/native-stack"
import { StackScreenProps } from "@react-navigation/stack"
import { CompositeScreenProps } from "@react-navigation/native"
import { PlaygroundScreen } from "./index"
import { Appbar } from "react-native-paper"
import { Screen } from "../../components"
import { getHeaderTitle } from "@react-navigation/elements"
import { translate } from "../../i18n"
import { PhotosScreen } from "./PhotosScreen"
import { useAppTheme } from "../../theme"

export type PlaygroundTabParamList = {
  Playground: undefined,
  Photos: undefined
}

/**
 * Helper for automatically generating navigation prop types for each route.
 *
 * More info: https://reactnavigation.org/docs/typescript/#organizing-types
 */
export type PlaygroundTabScreenProps<T extends keyof PlaygroundTabParamList> = CompositeScreenProps<
  StackScreenProps<PlaygroundTabParamList, T>,
  BaseScreenProps<keyof NavigatorParamList>
>


const Stack = createNativeStackNavigator<PlaygroundTabParamList>()

export function PlaygroundNavigator() {
  const { colors } = useAppTheme()
  return (
    <Screen
      preset="fixed"
      safeAreaEdges={[]}
      contentContainerStyle={{
        backgroundColor: colors.background,
        flex: 1,
      }}
    >
      <Stack.Navigator
        initialRouteName="Playground"
        screenOptions={{
          header: Header,
          animation: "slide_from_right",
        }}
      >
        <Stack.Screen
          name="Playground"
          component={PlaygroundScreen}
          options={{
            title: translate("playgroundScreen.headerTitle"),
            headerTintColor: colors.secondaryContainer,
          }}
        />
        <Stack.Screen
          name="Photos"
          component={PhotosScreen}
          options={{
            title: translate("photosScreen.headerTitle"),
            headerTintColor: "darksalmon",
          }}
        />
      </Stack.Navigator>
    </Screen>
  )
}

const Header = ({ navigation, route, options, back }) => {
  const title = getHeaderTitle(options, route.name)

  return (
    <Appbar.Header
      style={{
        backgroundColor: options.headerTintColor,
      }}
      elevated={true}
      mode="center-aligned"
    >
      {back ? <Appbar.BackAction onPress={navigation.goBack} /> : null}
      <Appbar.Content title={title} />
    </Appbar.Header>
  )
}