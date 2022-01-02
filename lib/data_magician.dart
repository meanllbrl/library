import 'package:flutter/material.dart';
import 'package:mean_lib/statefull_wrapper.dart';

//future ile data çekme
class DataMagicianFuture extends StatelessWidget {
  //properties: success trigger / dataLoadMethod / onError / onSuccess / onLoading
  const DataMagicianFuture(
      {Key? key,
      this.onLoading,
      this.loadingWidget,
      this.onError,
      this.errorWidget,
      required this.future,
      required this.ui,
      this.defaultTextStyle = const TextStyle()})
      : super(key: key);
  final Function? onLoading;
  final Widget? loadingWidget;
  final Function? onError;
  final Widget? errorWidget;
  final Widget ui;
  final Future future;
  final TextStyle defaultTextStyle;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, data) {
        //data yüklenme durumu
        if (data.connectionState == ConnectionState.waiting) {
          onLoading!();
          return loadingWidget ?? const CircularProgressIndicator();
        }
        if (data.hasError) {
          onError!();
          return errorWidget ??
              Center(
                child: Text(
                  "Data Error",
                  style: defaultTextStyle,
                ),
              );
        }
        if (data.hasData) {
          debugPrint("Data is exist!");
        }
        return ui;
      },
    );
  }
}

//USAGE
// DataMagicianProvider(
// onError:(){} //fonksiyon olarak kullanılıyor log olarak kullanılabilir. Çağırılmayabilir
// loadDataFunction:(){} //datanın yükleneceki fonksiyon init olark çağırılacak
// triggerCondition: //providerdan gelecek bir condition olacak mesela /dataList.lenght==5/
// ui: Container() //data yüklendikten sonra gösterilecek tasarım. Çağırılmayabilir
// placeHolder: Circular //data yüklenirken gösterilen widget. Çağırılmayabilir
// errorWidget: Hata oluşması durumunda gösterilecek widget. Çağırılmayabilir
// )

//provider ile data çekme
// ignore: must_be_immutable
class DataMagicianProvider extends StatelessWidget {
  DataMagicianProvider(
      {Key? key,
      required this.loadDataFunction,
      this.onError,
      required this.triggerCondition,
      this.ui,
      this.placeHolder,
      this.errorWidget,
      this.onFinished,
      this.defaultTextStyle = const TextStyle()})
      : super(key: key);
  final Function loadDataFunction;
  final Function? onError;
  final bool triggerCondition;
  final Widget? ui;
  final Widget? placeHolder;
  final Widget? errorWidget;
  final TextStyle defaultTextStyle;
  final Function? onFinished;
  bool hasErrorOccured = false;
  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
      onInit: () {
        //triggera bakılmalı burada.
        if(triggerCondition){ try {
          loadDataFunction().then((value){
            if (onFinished!=null) {
              onFinished!();
            }
            
          });
        } catch (e) {
          debugPrint(e.toString());
          hasErrorOccured = true;
          if (onError != null) {
            onError!();
          }
        }}
       
      },
      child: hasErrorOccured
          ? errorWidget ??
              Center(
                child: Text(
                  "upps! Something went wrong.",
                  style: defaultTextStyle,
                ),
              )
          : triggerCondition
              ? ui ??
                  // ignore: avoid_unnecessary_containers
                  Container(
                    child: Center(
                      child: Text(
                        "No Ui Detected!",
                        style: defaultTextStyle,
                      ),
                    ),
                  )
              : placeHolder ?? const CircularProgressIndicator(),
    );
  }
}
