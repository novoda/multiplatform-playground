import React, { ErrorInfo } from "react"
import { ScrollView, View, ViewStyle } from "react-native"
import { Icon, Screen } from "../../components"
import { Button, Text } from "react-native-paper"
import { spacing } from "../../theme"
import { translate } from "../../i18n"
import { useAppTheme } from "../../theme/theme"

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
        <Icon icon="ladybug" size={64} />
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
