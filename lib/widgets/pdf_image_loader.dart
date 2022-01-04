import 'package:flutter/material.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart';
import 'package:paint_to_print/widgets/loading_cube_grid.dart';

class PdfImageLoader extends StatelessWidget {
  final Map<int, PdfPageImage> storage;
  final PdfDocument document;
  final int pageNumber;

  PdfImageLoader({
    @required this.storage,
    @required this.document,
    @required this.pageNumber,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: _renderPage(),
        builder: (context, AsyncSnapshot<PdfPageImage> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          if (!snapshot.hasData) {
            return Center(child: LoadingCubeGrid());
          }
          return Image(image: MemoryImage(snapshot.data.bytes));
        },
      ),
    );
  }

  Future<PdfPageImage> _renderPage() async {
    if (storage.containsKey(pageNumber)) {
      return storage[pageNumber];
    }
    final page = await document.getPage(pageNumber);
    final pageImage = await page.render(
      width: page.width * 2,
      height: page.height * 2,
      format: PdfPageFormat.PNG,
    );
    await page.close();
    storage[pageNumber] = pageImage;
    return pageImage;
  }
}
