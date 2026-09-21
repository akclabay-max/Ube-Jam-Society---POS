// lib/sync/backend_connector.dart
import 'package:powersync/powersync.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyBackendConnector extends PowerSyncBackendConnector {
  final PowerSyncDatabase db;

  MyBackendConnector(this.db);

  @override
  Future<PowerSyncCredentials?> fetchCredentials() async {
    final session = Supabase.instance.client.auth.currentSession;
    if (session == null) {
      throw AssertionError('User is not logged in');
    }
    return PowerSyncCredentials(
      endpoint: 'https://YOUR_INSTANCE.powersync.journeyapps.com',
      token: session.accessToken,
    );
  }

  @override
  Future<void> uploadData(PowerSyncDatabase database) async {
    final transaction = await database.getNextCrudTransaction();
    if (transaction == null) return;

    final supabase = Supabase.instance.client;

    for (final op in transaction.crud) {
      final table = supabase.from(op.table);
      switch (op.op) {
        case UpdateType.put:
          await table.upsert({'id': op.id, ...?op.opData});
          break;
        case UpdateType.patch:
          await table.update(op.opData!).eq('id', op.id);
          break;
        case UpdateType.delete:
          await table.delete().eq('id', op.id);
          break;
      }
    }

    await transaction.complete();
  }
}