import 'package:http/http.dart';
import 'package:flutter/services.dart';
import 'package:web3dart/contracts.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart';

import 'main.dart';

class ContactsApi {
  String address = '0x64091cF01f32C104DbBB80b57C537738d171A253';
  String ethereumClientUrl =
      'https://goerli.infura.io/v3/df064891c10a4d83bab826e180ded69e';
  String contractName = "Contacts";
  String private_key =
      "2bf5961a4a4217b100f56aa761cf3094e06eed5ee8c308b91fde23418c65a048";
  late List<ContactModel> contacts;

  getContract() async {
    String abi = await rootBundle.loadString("assets/abi.json");
    String contractAddress = "0x702f1C30b26Af124209025161c58068216b2602C";
    final contract = DeployedContract(ContractAbi.fromJson(abi, private_key),
        EthereumAddress.fromHex(contractAddress));
    return contract;
  }

  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    DeployedContract contract = await getContract();
    var ethereumClient = await getClient();
    ContractFunction function = contract.function(functionName);
    List<dynamic> result = await ethereumClient.call(
        contract: contract, function: function, params: args);
    return result;
  }

  Future<String> transaction(String functionName, List<dynamic> args) async {
    EthPrivateKey credential = EthPrivateKey.fromHex(private_key);
    DeployedContract contract = await getContract();
    var ethereumClient = await getClient();
    ContractFunction function = contract.function(functionName);
    dynamic result = await ethereumClient.sendTransaction(
      credential,
      Transaction.callContract(
        contract: contract,
        function: function,
        parameters: args,
      ),
      fetchChainIdFromNetworkId: true,
      chainId: null,
    );

    return result;
  }

  getClient() async {
    var httpClient = new Client();
    var ethClient = new Web3Client(ethereumClientUrl, httpClient);
    return ethClient;
  }

  getAllContacts() async {
    List<ContactModel> cs = [];
    var count = await query('totalContacts', []);
    for (int i = 1; i <= int.parse(count[0].toString()); i++) {
      var res = await query('contacts', [BigInt.from(i)]);
      cs.add(new ContactModel(res));
    }
    return cs;
  }

  createContact(String name, String phone, String desc) async {
    var res = await transaction('createContact', [name, phone, desc]);
    print("res : ${res.toString()}");
  }

  editContact(ContactModel contactModel) async {
    var res = await transaction('editContact', [
      contactModel.id,
      contactModel.name,
      contactModel.phone,
      contactModel.desc
    ]);
    print("res : ${res.toString()}");
  }

  deleteContact(ContactModel contactModel) async {
    var res = await transaction('deleteContact', [contactModel.id]);
    print("res : ${res.toString()}");
  }
}
