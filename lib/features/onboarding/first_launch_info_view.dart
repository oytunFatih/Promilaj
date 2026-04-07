import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:promilaj/core/theme/app_colors.dart';
import 'package:promilaj/features/onboarding/onboarding_view.dart';
import 'package:promilaj/l10n/app_localizations.dart';

class FirstLaunchInfoView extends StatelessWidget {
  const FirstLaunchInfoView({super.key});
  String _deviceLangCode() {
    final locale = WidgetsBinding.instance.platformDispatcher.locale;
    final lang = locale.languageCode;
    if (lang == 'tr' || lang == 'az') return lang;
    return 'en';
  }

  List<_InfoSection> _sections(String lang) {
    const data = {
      'tr': [
        _InfoSection(
          title: 'Promilaj Nedir?',
          body:
              'Promilaj, kan alkol seviyenizi (BAC) Widmark formülüyle hesaplayan bir araçtır. '
              'Bulunduğunuz ülkenin yasal limitlerini gösterir ve ne zaman araç kullanabileceğinizi tahmin eder.',
        ),
        _InfoSection(
          title: 'Lütfen Dikkat',
          body:
              'Alkollüyken araç kullanmayın. Bu uygulama bir alkol ölçer cihazının yerini tutmaz; '
              'yalnızca tahmini bir hesaplama sunar. Emin olmak için her zaman bekleyin.',
        ),
        _InfoSection(
          title: 'Konum İzni',
          body:
              'Bulunduğunuz ülkeye göre yasal alkol limitini otomatik gösterebilmek için konumunuza '
              'ihtiyaç duyuyoruz. Konum bilginiz cihazınızda kalır, hiçbir sunucuya gönderilmez.',
        ),
        _InfoSection(
          title: 'Neden Bu Bilgileri İstiyoruz?',
          body:
              'Ağırlık, boy ve içtiğiniz içeceğin türü kan alkol seviyenizi doğrudan etkiler. '
              'Girdiğiniz bilgiler yalnızca hesaplama amacıyla kullanılır, saklanmaz veya paylaşılmaz.',
        ),
        _InfoSection(
          title: 'Biyolojik Cinsiyet mi, Cinsiyet mi?',
          body:
              'Widmark formülü vücuttaki su ve yağ oranına dayandığından biyolojik cinsiyet (erkek/kadın) sorar. '
              'Bu soru cinsiyet kimliğinizle ilgili değildir; yalnızca metabolizma hesabı içindir.',
        ),
        _InfoSection(
          title: 'Promil (‰) Nedir?',
          body:
              'Promil, binde bir anlamına gelir. Kanda 1‰ alkol, her 1.000 gram kanda 1 gram alkol demektir. '
              'Yüzde yerine binde kullanılır çünkü kan alkol seviyeleri çok küçük miktarlarla ifade edilir.',
        ),
        _InfoSection(
          title: 'Yasal Uyarı',
          body:
              'Bu uygulama yalnızca bilgilendirme amaçlıdır. Sunulan değerler tahminidir; gerçek kan alkol '
              'seviyeniz farklılık gösterebilir. Yaş, ilaç kullanımı, tokluk durumu ve genetik faktörler her '
              'bireyin metabolizmasını etkiler. Yasal bir karar öncesinde onaylı bir alkol ölçer kullanınız. '
              'Geliştirici ve uygulama, bu bilgiler doğrultusunda alınan kararlardan sorumlu tutulamaz.',
        ),
      ],
      'az': [
        _InfoSection(
          title: 'Promilaj Nədir?',
          body:
              'Promilaj, Widmark düsturu ilə qan spirt səviyyənizi (BAC) hesablayan bir vasitədir. '
              'Ölkənizdəki qanuni limitləri göstərir və avtomobil sürə biləcəyiniz vaxtı təxmin edir.',
        ),
        _InfoSection(
          title: 'Diqqət Edin',
          body:
              'Spirt içkisi içdikdən sonra avtomobil sürmə. Bu tətbiq alkomat cihazının əvəzini tutmur; '
              'yalnız təxmini hesablama təqdim edir. Əmin olmaq üçün həmişə gözləyin.',
        ),
        _InfoSection(
          title: 'Məkan İcazəsi',
          body:
              'Ölkənizə görə qanuni spirt limitini avtomatik göstərmək üçün məkanınıza ehtiyacımız var. '
              'Məkan məlumatlarınız cihazınızda qalır, heç bir serverə göndərilmir.',
        ),
        _InfoSection(
          title: 'Niyə Bu Məlumatları İstəyirik?',
          body:
              'Çəki, boy və içdiyiniz içkinin növü qan spirt səviyyənizə birbaşa təsir edir. '
              'Daxil etdiyiniz məlumatlar yalnız hesablama məqsədilə istifadə olunur, saxlanmır və paylaşılmır.',
        ),
        _InfoSection(
          title: 'Bioloji Cins mi, Gender mi?',
          body:
              'Widmark düsturu bədəndəki su və yağ nisbətinə əsaslandığından bioloji cinsi (kişi/qadın) soruşur. '
              'Bu sual cinsiyet kimliyinizlə əlaqəli deyil; yalnız metabolizm hesabı üçündür.',
        ),
        _InfoSection(
          title: 'Promil (‰) Nədir?',
          body:
              'Promil mində bir deməkdir. Qanda 1‰ spirt hər 1.000 qram qanda 1 qram spirt deməkdir. '
              'Faiz əvəzinə mində istifadə olunur, çünki qan spirt səviyyələri çox kiçik miqdarlarla ifadə edilir.',
        ),
        _InfoSection(
          title: 'Hüquqi Xəbərdarlıq',
          body:
              'Bu tətbiq yalnız məlumat məqsədilə nəzərdə tutulmuşdur. Təqdim olunan dəyərlər təxminidir; '
              'real qan spirt səviyyəniz fərqli ola bilər. Yaş, dərman istifadəsi, toxluq vəziyyəti və genetik '
              'amillər hər fərdin metabolizminə təsir edir. Hər hansı hüquqi qərar əvvəl sertifikatlı alkomat '
              'istifadə edin. Proqramçı və tətbiq bu məlumatlar əsasında qəbul edilən qərarlardan məsul tutula bilməz.',
        ),
      ],
      'en': [
        _InfoSection(
          title: 'What Is Promilaj?',
          body:
              'Promilaj is a tool that estimates your blood alcohol concentration (BAC) using the Widmark formula. '
              'It shows the legal limits for your country and estimates when you can safely drive again.',
        ),
        _InfoSection(
          title: 'Please Note',
          body:
              'Never drive under the influence of alcohol. This app is not a substitute for a breathalyzer; '
              'it provides estimates only. When in doubt, always wait.',
        ),
        _InfoSection(
          title: 'Location Permission',
          body:
              'We use your location to automatically display the legal alcohol limit for your country. '
              'Your location stays on your device and is never sent to any server.',
        ),
        _InfoSection(
          title: 'Why Do We Ask for This Information?',
          body:
              'Your weight, height, and the type of drink you consumed directly affect your blood alcohol level. '
              'The information you enter is used solely for calculation and is never stored or shared.',
        ),
        _InfoSection(
          title: 'Biological Sex vs. Gender',
          body:
              'The Widmark formula is based on body water and fat ratios, so it asks for your biological sex '
              '(male/female). This question is not about your gender identity; it is used only for metabolic calculation.',
        ),
        _InfoSection(
          title: 'What Is Promille (‰)?',
          body:
              'Promille means per thousand. A BAC of 1‰ means 1 gram of alcohol per 1,000 grams of blood. '
              'Promille is used instead of percent because blood alcohol levels are expressed in very small amounts.',
        ),
        _InfoSection(
          title: 'Legal Disclaimer',
          body:
              'This app is for informational purposes only. The values provided are estimates; your actual blood '
              'alcohol level may differ. Age, medication, food intake, and genetic factors affect each individual\'s '
              'metabolism differently. Use a certified breathalyzer before making any legal decision. The developer '
              'and this application cannot be held responsible for any decisions made based on this information.',
        ),
      ],
    };
    return data[lang]!;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lang = _deviceLangCode();
    final sections = _sections(lang);
    return Scaffold(
      backgroundColor: AppColors.midnight,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.surface, AppColors.midnight],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 24),
                Expanded(
                  child: ListView.separated(
                    itemCount: sections.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 20),
                    itemBuilder: (context, index) {
                      final section = sections[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            section.title,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.3,
                                ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            section.body,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: AppColors.textPrimary.withOpacity(
                                    0.75,
                                  ),
                                  height: 1.6,
                                ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('info_screen_shown', true);
                      if (context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const OnboardingView(),
                          ),
                        );
                      }
                    },
                    child: Text(l10n.infoScreenNext),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoSection {
  final String title;
  final String body;
  const _InfoSection({required this.title, required this.body});
}
