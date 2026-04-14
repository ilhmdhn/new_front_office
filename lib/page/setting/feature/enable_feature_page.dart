import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:front_office_2/page/style/custom_color.dart';
import 'package:front_office_2/page/style/custom_text.dart';
import 'package:front_office_2/riverpod/feature_provider.dart';

class EnableFeaturePage extends ConsumerWidget {
  const EnableFeaturePage({super.key});
  static const nameRoute = '/enable-feature';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: CustomColorStyle.background(),
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color:  Colors.white, //change your color here
        ),
        title: Text('Fitur Diaktifkan', style: CustomTextStyle.titleAppBar(), textAlign: TextAlign.start,),
        backgroundColor: CustomColorStyle.appBarBackground(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(9)
                ),
                child: CheckboxListTile(
                  activeColor: const Color(0xFF1976D2),
                  checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  title: Text('Rating' ,style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                  ),
                  subtitle: Text('Fitur rating dari customer', style: const TextStyle(fontSize: 12)),
                  value: ref.watch(ratingFeatureProvider),
                  onChanged: (bool? value) async{
                    ref.read(ratingFeatureProvider.notifier).setRatingFeature(value??false);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}