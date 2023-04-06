import React, { ErrorInfo } from "react"
import { Image, ScrollView, View, ViewStyle } from "react-native"
import { iconRegistry, Screen } from "../../components"
import { Button, Text } from "react-native-paper"
import { spacing, useAppTheme } from "../../theme"
import { translate } from "../../i18n"

export interface ErrorDetailsProps {
  error: Error
  errorInfo: ErrorInfo

  onReset(): void
}

export function ErrorDetails(props: ErrorDetailsProps) {
  const colors = useAppTheme().colors
  return (
    <Screen
      preset="fixed"
      safeAreaEdges={["top", "bottom"]}
      contentContainerStyle={$contentContainer}
    >
      <View style={$topSection}>
        <Image source={iconRegistry.ladybug} style={{ width: 64, height: 54 }} />
        <Text
          style={{
            color: colors.error,
            marginBottom: spacing.medium,
          }}
          variant="headlineSmall"
          children={translate("errorScreen.title")} />
        <Text children={translate("errorScreen.friendlySubtitle")} />
      </View>

      <ScrollView
        style={{
          flex: 2,
          backgroundColor: colors.backdrop,
          marginVertical: spacing.medium,
          borderRadius: 6,
        }}
        contentContainerStyle={$errorSectionContentContainer}>
        <Text style={{
          color: colors.error,
          fontWeight: "bold",
        }} children={`${props.error}`.trim()} />
        <Text
          selectable
          style={{
            marginTop: spacing.medium,
            color: colors.onSecondaryContainer,
          }}
          children={`${props.errorInfo.componentStack}`.trim()}
        />
      </ScrollView>

      <Button
        mode={"contained"}
        contentStyle={$resetButton}
        buttonColor={colors.error}
        onPress={props.onReset}
        children={translate("errorScreen.reset")}
      />
    </Screen>
  )
}

const $contentContainer: ViewStyle = {
  alignItems: "center",
  paddingHorizontal: spacing.large,
  paddingVertical: spacing.extraLarge,
  flex: 1,
}

const $topSection: ViewStyle = {
  flex: 1,
  alignItems: "center",
}

const $errorSectionContentContainer: ViewStyle = {
  padding: spacing.medium,
}

const $resetButton: ViewStyle = {
  paddingHorizontal: spacing.huge,
}
