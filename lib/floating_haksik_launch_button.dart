import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:launch_review/launch_review.dart';

class FloatingHakSikLaunchButton extends FloatingActionButton {
    FloatingHakSikLaunchButton({Key? key}): super(key: key, 
        backgroundColor: Colors.cyan,
        onPressed: () async {
            const haksikPackageName = 'kr.co.haksik';

            if (await DeviceApps.isAppInstalled(haksikPackageName)) {
                //학식앱이 설치되어있으면 launch
                DeviceApps.openApp(haksikPackageName);
            } else {//아니면 play store 학식 설치페이지로 이동
                //TODO 추후 ios
                LaunchReview.launch(androidAppId: haksikPackageName);
            }
        },
        child: Image.asset('asset/ticket.png', width: 35, height: 35,)
    );
}
