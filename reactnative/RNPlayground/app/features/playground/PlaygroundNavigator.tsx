import * as React from "react"
import { BaseScreenProps, NavigatorParamList } from "../../navigators"
import { createNativeStackNavigator } from "@react-navigation/native-stack"
import { StackScreenProps } from "@react-navigation/stack"
import { CompositeScreenProps } from "@react-navigation/native"
import { PlaygroundScreen } from "./index"
import { Appbar } from "react-native-paper"
import { colors } from "../../theme"
import { View } from "react-native"
import { Screen, Text } from "../../components"
import { getHeaderTitle } from "@react-navigation/elements"
import { translate } from "../../i18n"
import { PhotosReduxScreen } from "./PhotosReduxScreen"

export type PlaygroundTabParamList = {
  Playground: undefined,
  PhotosRedux: undefined
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
            headerTintColor: colors.tint,
          }}

        />
        <Stack.Screen
          name="PhotosRedux"
          component={PhotosReduxScreen}
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
      mode="medium"
    >
      {back ? <Appbar.BackAction onPress={navigation.goBack} /> : null}
      <Appbar.Content title={<HeaderTitle text={title} />} />
    </Appbar.Header>
  )
}

const HeaderTitle = ({ text }: { text: string }) => (
  <View>
    <Text
      testID="welcome-heading"
      text={text}
      preset="heading"
    />
  </View>
)