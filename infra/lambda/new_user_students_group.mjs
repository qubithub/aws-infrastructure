import {
  CognitoIdentityProviderClient,
  AdminAddUserToGroupCommand
} from "@aws-sdk/client-cognito-identity-provider";

const client = new CognitoIdentityProviderClient();

export const handler = async (event) => {
  // Only run after the user is confirmed
  if (event.triggerSource === "PostConfirmation_ConfirmSignUp") {
    const command = new AdminAddUserToGroupCommand({
      UserPoolId: event.userPoolId,
      Username: event.userName,
      GroupName: "students",
    });

    await client.send(command);
  }

  return event;
};