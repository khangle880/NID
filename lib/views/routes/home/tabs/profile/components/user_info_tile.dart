// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// 🌎 Project imports:
import 'package:nid/logic/blocs/profile/profile_bloc.dart';
import 'package:nid/views/routes/home/tabs/profile/components/change_avatar_button.dart';
import 'package:nid/views/utils/extensions/view_extensions.dart';
import 'package:nid/views/widgets/network_avatar.dart';
import 'descr_text_field.dart';
import 'name_text_field.dart';

class UserInfoTile extends StatefulWidget {
  const UserInfoTile({Key? key}) : super(key: key);

  @override
  _StateUserInfoTile createState() => _StateUserInfoTile();
}

class _StateUserInfoTile extends State<UserInfoTile> {
  RewardedAd? rewardedAd;
  int rewardedAdAttempts = 0;
  int maxAttempts = 3;

  void createRewardedAd() {
    RewardedAd.load(
        adUnitId: "ca-app-pub-7302379484663726/9930879697",
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) {
          rewardedAd = ad;
          rewardedAdAttempts = 0;
        }, onAdFailedToLoad: (error) {
          rewardedAdAttempts++;
          rewardedAd = null;
          print('failed to load ${error.message}');

          if (rewardedAdAttempts <= maxAttempts) {
            createRewardedAd();
          }
        }));
  }

  ///function to show the rewarded ad after loading it
  ///this function will get called when we click on the button
  void showRewardedAd() {
    if (rewardedAd == null) {
      print('trying to show before loading');
      return;
    }

    rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) => print('ad showed $ad'),
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          createRewardedAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          print('failed to show the ad $ad');

          createRewardedAd();
        });

    rewardedAd!.show(onUserEarnedReward: (ad, reward) {
      print('reward video ${reward.amount} ${reward.type}');
    });
    rewardedAd = null;
  }

  @override
  void initState() {
    createRewardedAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            textColor: Colors.black,
            trailing: Icon(
              Icons.settings,
              color: Colors.black,
            ),
            title: Row(
              children: <Widget>[
                SizedBox(width: 1.w),
                NetworkAvatar(
                  link: state.userInfo.avatarLink,
                  width: 64.h,
                  height: 64.h,
                ),
                SizedBox(width: 10.w),
                SizedBox(
                  width: 180.w,
                  child: ListTile(
                    title: Text(
                      state.userInfo.name,
                      style: textTheme.subtitle1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      state.userInfo.email,
                      style: textTheme.button!.toBlurColor(),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
              ],
            ),
            childrenPadding: EdgeInsets.symmetric(horizontal: 10.w),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  ChangeAvatarButton(),
                  Spacer(),
                  NameTextField(),
                ],
              ),
              DescriptionTextField(),
              SizedBox(
                width: 150.w,
                child: TextButton(
                  onPressed: () {
                    showRewardedAd();
                    context.read<ProfileBloc>().add(SaveProfile());
                  },
                  child: Text(
                    "Save Info",
                    textAlign: TextAlign.center,
                    style: textTheme.subtitle1!.copyWith(
                      fontSize: 16.sp,
                      color: ExpandedColor.fromHex("#F96969"),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
