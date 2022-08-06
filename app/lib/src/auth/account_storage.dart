import 'package:better_mcfallout_bot/src/better_mcfallout_bot.dart';

const AccountStorage accountStorage = AccountStorage();

class AccountStorage {
  const AccountStorage();

  bool hasAnyAccount() => getAll().isNotEmpty;

  List<Account> getAll() {
    final List<String> json =
        ConfigHelper.get<List>('accounts', defaultValue: [])!.cast();
    return json.map((account) => Account.fromJson(account)).toList();
  }

  Account? get(String uuid) {
    try {
      return getAll().firstWhere((account) => account.uuid == uuid);
    } on StateError {
      return null;
    }
  }

  Future<void> add(Account account) async {
    final accounts = getAll();
    accounts.removeWhere((e) => e.uuid == account.uuid);
    accounts.add(account);

    await _set(accounts);
  }

  Future<void> remove(String uuid) async {
    await _set(getAll().where((account) => account.uuid != uuid).toList());
  }

  Account? getDefault() {
    if (hasAnyAccount()) {
      final String uuid = ConfigHelper.get<String>('default_account',
          defaultValue: getAll().first.uuid)!;

      return get(uuid) ?? getAll().first;
    } else {
      return null;
    }
  }

  Future<void> setDefault(String uuid) async {
    await ConfigHelper.set<String>('default_account', uuid);
  }

  int get count => getAll().length;

  Future<void> _set(List<Account> accounts) async {
    await ConfigHelper.set(
        'accounts', accounts.map((e) => e.toJson()).toList());
  }
}
