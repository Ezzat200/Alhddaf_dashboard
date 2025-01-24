import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haddaf_ashboard/core/dio_helper.dart';
import 'package:haddaf_ashboard/screens/dashboard/model/portfolio_model.dart';
import 'package:haddaf_ashboard/screens/dashboard/view_model/state.dart';

class PortofolioCubit extends Cubit<PortofolioState> {
  PortfolioModel? portfolioModel;

  PortofolioCubit() : super(PortofolioInitial());

  static PortofolioCubit get(context) => BlocProvider.of(context);
String ?selectedImage;
pickImage( BuildContext context) async {

  try {
    // showDialog(context: context, builder: (context) {
    //   return Center(child: CircularProgressIndicator(),);
    // },);
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.media,
      allowMultiple: false,
    );

    if (result != null) {
      final dio = Dio();
      var formData;

      // Check if we're on the web platform
      if (kIsWeb) {
        // For web, use the `bytes` property
        formData = FormData.fromMap({
          "folder_name": "test",
          "file": MultipartFile.fromBytes(
            result.files.single.bytes!,
            filename: result.files.single.name,
          ),
        });
      } else {
        // For mobile/desktop, use the `path` property
        formData = FormData.fromMap({
          "folder_name": "test",
          "file": await MultipartFile.fromFile(
            result.files.single.path!,
            filename: result.files.single.name,
          ),
        });

      }
      var response = await dio.post("https://orikvision.com/backend/upload", data: formData);
      selectedImage = response.data['file_url'].toString();
      log(selectedImage??'empty');
      // emit(PortofolioLoaded());
      // Navigator.pop(context);

    } else {
      log("else");
      // Navigator.pop(context);
    }
  } catch (e) {
    log(e.toString());
      // Navigator.pop(context);

  }
}

  getAllDataPortofolio() async {
    emit(PortofolioLoading()); // حالة تحميل البيانات
    try {
      var queryParameters = {
        "table_name": 'portfolios',
        "type": '',
      };
      final Response response = await DioHelper.getData(
        url: 'https://orikvision.com/backend/get_data',
        queryParameters: queryParameters,
      );

      portfolioModel = PortfolioModel.fromJson(response.data);
      log(response.data.toString());

      emit(PortofolioLoaded());
    } on DioException catch (e) {
      log(e.message.toString());
      emit(PortofolioError(e.message.toString()));
    }
  }

  Future<void> addItem({
    required String title,
    required String description,
    required String subservice,
    // required String type,
    required bool isMost,
    // required File? selectedImage, // هنا نستخدم Uint8List
    required List<Map<String, String>> contentData,
  }) async {
    try {
      final List<Content> contentList = contentData
          .map((item) => Content(
                type: item['type'] ?? '',
                value: item['value'] ?? '',
              ))
          .toList();

      final newData = Data(
        cover: "selectedImage",
        content: contentList,
        description: description,
        id: DateTime.now().millisecondsSinceEpoch,
        isMost: isMost ? 1 : 0,
        subservice: subservice,
        title: title,
        type: 'type',
      );

      // FormData formData = FormData.fromMap({
      //   "title": newData.title,
      //   "description": newData.description,
      //   "subservice": newData.subservice,
      //   "type": newData.type,
      //   "isMost": newData.isMost,
      //   "cover": selectedImage,
      //   "content": newData.content!
      //       .map((e) => {
      //             "type": e.type,
      //             "value": e.value,
      //           })
      //       .toList(),
      //   "table_name": "portfolios",
      // });

      // إرسال البيانات باستخدام Dio
      emit(PortofolioLoading());


      if (this. selectedImage == null) {
        return ;
      }
      // final responseImage = await DioHelper.postData(
      //     url: "https://orikvision.com/backend/upload",
      //     data: {
      //       "folder_name": "test",
      //       "file": selectedImage,
      //     });
      // log(responseImage.data['file_url'].toString());
print(newData.content);
      final response = await DioHelper.postData(
        url: 'https://orikvision.com/backend/add_item',
        
        data: 
        {
    

          "title": newData.title,
          "description": newData.description,
          "subservice": 'newData.subservice',
          "type": 'newData.type',
          "isMost": false,
          "cover": this.selectedImage,
          "data": newData.content!
          
              .map((Content e) => {
                    "type": e.type,
                    "value": e.value,
                  })
              .toList(),
          "table_name": "portfolios",
        },
      );

      if (response.statusCode == 200 && response.data['status']) {
        log('Item added successfully: ${newData.toString()}');
        emit(PortofolioLoaded());
      } else {
        emit(PortofolioError(response.data['message'] ?? 'Error adding item'));
      }
    } catch (error) {
      log('Error adding item: $error');
      emit(PortofolioError(error.toString()));
    }
  }
}
