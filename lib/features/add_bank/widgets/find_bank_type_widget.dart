import 'package:flutter/material.dart';
import 'package:viet_qr_plugin/commons/configurations/theme.dart';
import 'package:viet_qr_plugin/commons/env/env_config.dart';
import 'package:viet_qr_plugin/features/add_bank/repositories/bank_type_repository.dart';
import 'package:viet_qr_plugin/features/add_bank/views/add_bank_s2_view.dart';
import 'package:viet_qr_plugin/models/bank_type_dto.dart';

class FindBankTypeWidget extends StatefulWidget {
  final double width;
  final double height;
  final TextEditingController searchController = TextEditingController();
  BankTypeRepository bankTypeRepository = const BankTypeRepository();

  FindBankTypeWidget({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FindBankTypeWidget();
}

class _FindBankTypeWidget extends State<FindBankTypeWidget> {
  List<BankTypeDTO> _bankTypes = [];
  List<BankTypeDTO> _bankTypesTemp = [];

  @override
  void initState() {
    super.initState();
    getBankTypes();
  }

  Future<void> getBankTypes() async {
    _bankTypes = await widget.bankTypeRepository.getBankTypes();
    _bankTypesTemp = _bankTypes;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Column(
        children: [
          const Padding(padding: EdgeInsets.only(top: 10)),
          Container(
            width: widget.width,
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColor.GREY_BORDER,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/ic-search.png',
                  width: 20,
                  height: 20,
                ),
                const Padding(padding: EdgeInsets.only(left: 10)),
                Expanded(
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TextField(
                      controller: widget.searchController,
                      decoration: const InputDecoration(
                        hintText: 'Tìm ngân hàng ở đây',
                        hintStyle: TextStyle(
                          color: AppColor.GREY_TEXT,
                          fontSize: 13,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(bottom: 12.5),
                      ),
                      onChanged: (text) {
                        _searchBankTypes();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 20)),
          if (_bankTypes.isNotEmpty && widget.searchController.text.isEmpty)
            Expanded(
              child: GridView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  // physics: NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 2,
                  ),
                  itemCount: _bankTypes.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddBankS2View(
                              bankTypeDTO: _bankTypes[index],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: 80,
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: AppColor.GREY_BORDER,
                            ),
                            image: DecorationImage(
                                image: NetworkImage(
                              EnvConfig.getImagePrefixUrl() +
                                  _bankTypes[index].imageId,
                            ))),
                      ),
                    );
                  }),
            ),
          if (_bankTypes.isNotEmpty && widget.searchController.text.isNotEmpty)
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: _bankTypes.length,
                separatorBuilder: (context, index) {
                  return const Divider(
                    color: AppColor.GREY_BORDER,
                  );
                },
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddBankS2View(
                            bankTypeDTO: _bankTypes[index],
                          ),
                        ),
                      );
                    },
                    child: SizedBox(
                      width: widget.width,
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: AppColor.GREY_BORDER,
                                ),
                                image: DecorationImage(
                                    image: NetworkImage(
                                  EnvConfig.getImagePrefixUrl() +
                                      _bankTypes[index].imageId,
                                ))),
                          ),
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          Expanded(
                            child: SizedBox(
                              height: 40,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _bankTypes[index].bankShortName,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    _bankTypes[index].bankName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: AppColor.GREY_TEXT,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          Image.asset(
                            'assets/images/ic-next-blue.png',
                            width: 20,
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          if (_bankTypes.isNotEmpty) ...[
            const Padding(padding: EdgeInsets.only(top: 10)),
            const Text(
              'Thêm tài khoản ngân hàng',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 30)),
          ],
        ],
      ),
    );
  }

  void _searchBankTypes() {
    if (widget.searchController.text.isEmpty) {
      setState(() {
        _bankTypes = _bankTypesTemp;
      });
    } else {
      String keyword = widget.searchController.text.toUpperCase();
      _bankTypes = _bankTypesTemp
          .where((element) =>
              element.bankCode.toString().toUpperCase().contains(keyword) ||
              element.bankShortName
                  .toString()
                  .toUpperCase()
                  .contains(keyword) ||
              element.bankName.toString().toUpperCase().contains(keyword))
          .toList();
      setState(() {});
    }
  }
}
