import 'dart:io';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

void main() async {
  // Use a nullable type for the token
  final String? token = Platform.environment['TOKEN'];

  // Check if the token environment variable is set
  if (token == null) {
    print('Token not found. Please set the TOKEN environment variable.');
    exit(1);
  }

  // Create a new instance of the Nyxx client
  // You need GatewayIntents.messageContent for the prefix commands
  // and GatewayIntents.allUnprivileged for slash commands
  final client = NyxxFactory.createNyxxWebsocket(
    token,
    GatewayIntents.allUnprivileged | GatewayIntents.messageContent,
  );

  // Create a new instance of the CommandsPlugin
  // This will handle both prefix and slash commands
  final commands = CommandsPlugin(
    prefix: (message) => '!', // You can still use a prefix for regular commands
    options: CommandsOptions(
      logErrors: true,
      logInformation: true,
    ),
  );

  // Add the simple `/ping` command
  commands.addCommand(
    ChatCommand(
      'ping', // The name of the command
      'Responds with "Pong!".', // The description of the command
      (context) async {
        // The logic for the command
        await context.respond(MessageBuilder.content('Pong!'));
      },
    ),
  );

  // Register the commands plugin with the Nyxx client
  client.registerPlugin(commands);

  // Connect the client to Discord
  await client.connect();

  print('Bot is online!');
}
