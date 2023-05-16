// Libraries
//import 'package:flutter/material.dart';
import 'package:credit_card_type_detector/models.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart'
    show
    Scaffold,
    AppBar,
    TextField,
    TextInputAction,
    InputDecoration,
    MaterialButton;

// Packages
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import '../blocs/add_credit_card_bloc.dart';
import '../blocs/bloc.dart';


class AddCreditCardScreen extends StatelessWidget {
  BuildContext? _context;
  AddCreditCardBloc? _addCardBloc;
  final _addCCFormKey = new GlobalKey<FormState>(debugLabel: "addCCForm");
  final FocusNode _ccNumFocus = FocusNode();
  final FocusNode _expDateFocus = FocusNode();
  final FocusNode _cvvFocus = FocusNode();
  final FocusNode _nameFocus = FocusNode();

  final MaskedTextController _ccNumMask =
  MaskedTextController(mask: "0000 0000 0000 0000");
  final MaskedTextController _expMask = MaskedTextController(mask: "00/00");

  Widget _creditCardWidget() {
    Size deviceSize = MediaQuery.of(_context!).size;
    double ccIconSize = 50.0;
    double ccDrawingHeight = deviceSize.height * 0.3;
    double ccDrawingWidth = deviceSize.width * 0.8;

    return Container(
      height: ccDrawingHeight,
      color: Color(0xffe0e0e0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Center(
          child: Container(
            width: ccDrawingWidth,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(12.0),
              ),
              gradient: LinearGradient(
                colors: [
                  Color(0xff535252),
                  Color(0xff211e1e),
                ],
              ),
            ),

            // Overlay with credit card info
            child: Stack(
              children: <Widget>[
                // Credit Card number
                Positioned(
                  left: 20.0,
                  top: 30.0,
                  child: StreamBuilder<String>(
                    stream: _addCardBloc?.ccNum,
                    initialData: "XXXX XXXX XXXX XXXX",
                    builder: (context, snapshot) {
                      snapshot.data!.isNotEmpty
                          ? _ccNumMask.updateText(snapshot.data!)
                          : null;

                      return Text(
                        snapshot.data!.isNotEmpty
                            ? snapshot.data!
                            : "XXXX XXXX XXXX XXXX",
                        style: const TextStyle(
                          color: Color(0xffffffff),
                          fontSize: 20.0,
                        ),
                      );
                    },
                  ),
                ),

                // Credit Card Type Icon
                Positioned(
                  right: 20.0,
                  top: 15.0,
                  child: StreamBuilder(
                    stream: _addCardBloc?.ccType,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      Widget icon;
                      CreditCardType currType = snapshot.data;
                      switch (currType) {
                        case CreditCardType.visa:
                          icon = Icon(
                            FontAwesomeIcons.ccVisa,
                            size: ccIconSize,
                            color: const Color(0xffffffff),
                          );
                          break;

                        case CreditCardType.americanExpress:
                          icon = Icon(
                            FontAwesomeIcons.ccAmex,
                            size: ccIconSize,
                            color: const Color(0xffffffff),
                          );
                          break;

                        case CreditCardType.maestro:
                        case CreditCardType.mastercard:
                          icon = Icon(
                            FontAwesomeIcons.ccMastercard,
                            size: ccIconSize,
                            color: const Color(0xffffffff),
                          );
                          break;

                        case CreditCardType.discover:
                          icon = Icon(
                            FontAwesomeIcons.ccDiscover,
                            size: ccIconSize,
                            color: const Color(0xffffffff),
                          );
                          break;

                        case CreditCardType.dinersClub:
                          icon = Icon(
                            FontAwesomeIcons.ccDinersClub,
                            size: ccIconSize,
                            color: const Color(0xffffffff),
                          );
                          break;

                        case CreditCardType.jcb:
                          icon = Icon(
                            FontAwesomeIcons.ccJcb,
                            size: ccIconSize,
                            color: const Color(0xffffffff),
                          );
                          break;

                      // Don't have icons for the rest
                        default:
                          icon = Container(
                            color: const Color(0x00000000),
                          );
                      }

                      return icon;
                    },
                  ),
                ),

                // Expiration Date
                Positioned(
                  left: 20.0,
                  bottom: 60.0,
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Text(
                      //   "Good Thru",
                      //   style: TextStyle(
                      //     fontSize: 15.0,
                      //     fontWeight: FontWeight.w700,
                      //     color: Color(0xffffffff),
                      //   ),
                      // ),
                      StreamBuilder<String>(
                        stream: _addCardBloc?.expDate,
                        initialData: "MM/YY",
                        builder: (context, snapshot) {
                          snapshot.data!.isNotEmpty
                              ? _expMask.updateText(snapshot.data!)
                              : null;

                          return Text(
                            snapshot.data!.isNotEmpty ? snapshot.data! : "MM/YY",
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal,
                              color: Color(0xffffffff),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // CVV Code
                Positioned(
                  right: 20.0,
                  bottom: 60.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      StreamBuilder<String>(
                        stream: _addCardBloc?.cvv,
                        initialData: "CVV/CVC",
                        builder: (context, snapshot) {
                          return Text(
                            snapshot.data!.isNotEmpty
                                ? snapshot.data!
                                : "CVV/CVC",
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal,
                              color: Color(0xffffffff),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Cardholder Name
                Positioned(
                  left: 20.0,
                  bottom: 20.0,
                  child: StreamBuilder<String>(
                    stream: _addCardBloc?.cardholderName,
                    initialData: "Cardholder Name",
                    builder: (context, snapshot) {
                      return Text(
                        snapshot.data!,
                        style: const TextStyle(
                          color: Color(0xffffffff),
                          fontWeight: FontWeight.normal,
                          fontSize: 20.0,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputSection() {
    Size deviceSize = MediaQuery.of(_context!).size;

    return SizedBox(
      height: deviceSize.height * 0.1,
      width: deviceSize.width,
      child: Form(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                width: 250.0,
                child: TextField(
                  controller: _ccNumMask,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  focusNode: _ccNumFocus,
                  onSubmitted: (submission) {
                    _ccNumFocus.unfocus();
                    FocusScope.of(_context!).requestFocus(_expDateFocus);
                  },
                  autofocus: true,
                  maxLength: 19,
                  style: const TextStyle(
                    //fontFamily: UIData.ralewayFont,
                    color: Color(0xff000000),
                  ),
                  onChanged: (newCCNum) =>
                      _addCardBloc?.updateCCNum.add(_ccNumMask.text),
                  decoration: const InputDecoration(
                    labelText: "Credit Card Number",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                width: 100.0,
                child: TextField(
                  controller: _expMask,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  focusNode: _expDateFocus,
                  onSubmitted: (submission) {
                    _expDateFocus.unfocus();
                    FocusScope.of(_context!).requestFocus(_cvvFocus);
                  },
                  maxLength: 5,
                  style: const TextStyle(
                    color: Color(0xff000000),
                  ),
                  onChanged: (newExp) =>
                      _addCardBloc?.updateExp.add(_expMask.text),
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    labelText: "MM/YY",
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                width: 100.0,
                child: TextField(
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  focusNode: _cvvFocus,
                  onSubmitted: (submission) {
                    _cvvFocus.unfocus();
                    FocusScope.of(_context!).requestFocus(_nameFocus);
                  },
                  maxLength: 3,
                  style: const TextStyle(
                    color: Color(0xff000000),
                  ),
                  onChanged: (newCvv) => _addCardBloc?.updateCvv.add(newCvv),
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    labelText: "CVV/CVC",
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                width: 250.0,
                child: TextField(
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  focusNode: _nameFocus,
                  onSubmitted: (submission) {
                    _nameFocus.unfocus();
                  },
                  maxLength: 20,
                  style: const TextStyle(
                    color: Color(0xff000000),
                  ),
                  onChanged: (newName) => _addCardBloc?.updateName.add(newName),
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    labelText: "Cardholder Name",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonBar() {
    Size deviceSize = MediaQuery.of(_context!).size;

    Widget child = Container();
    // TODO Figure out how to change this through a form validationBLoC
    bool validated = true;
    if (validated) {
      child = MaterialButton(
        minWidth: deviceSize.width,
        height: 50.0,
        color: const Color(0xff4CD964),
        elevation: 0.0,
        onPressed: () => _saveCard,
        child: const Text(
          "Save Card",
          style: TextStyle(
            color: Color(0xffffffff),
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return child;
  }

  void _saveCard() {}

  @override
  Widget build(BuildContext context) {
    _context = context;
    _addCardBloc = BlocProvider.of<AddCreditCardBloc>(context) as AddCreditCardBloc?;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: const Color(0xffffffff),
        title: const Text(
          "Add Credit Card",
          style: TextStyle(
            color: Color(0xff000000),
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _creditCardWidget(),
          _inputSection(),
          Expanded(
            child: Center(
              child: _buttonBar(),
            ),
          ),
        ],
      ),
    );
  }
}