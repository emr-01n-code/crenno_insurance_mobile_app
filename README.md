# Insurance Mobile App

Kullanıcı aktif poliçeleri listeliyor, detaya giriyor, oradan hasar bildirimi formunu doldurabiliyor. Veriyi gerçek bir API’den çekmiyorum; `assets/mock` içindeki JSON’lara Dio ile gidiyorum.

## Yapılanlar

- **Poliçe listesi:** Aktif poliçeler (araç, sağlık, konut vb.) listeleniyor.
- **Async veri:** İstekler asenkron; mock JSON ve gecikme var.
- **Loading / error:** Yükleme ve hata durumları ayrı gösteriliyor, listede yenileme var.
- **Detay:** Poliçeye tıklayınca tarih ve teminat gibi bilgiler geliyor.
- **Hasar formu:** Olay tarihi (DatePicker) ve açıklama alanı; boş gönderim ve basit kurallar için validasyon var.
- **Teknik:** Riverpod, feature-first + katmanlı yapı (data / domain / presentation), Dio, GoRouter, standart mobil ekranda düzgün bir arayüz.

## Çalıştırma

```bash
flutter pub get
flutter run
```

Geliştirme ortamı: Flutter 3.38 / Dart 3.10.

## Kullandığım paketler

- `flutter_riverpod` — state management
- `dio` — HTTP istemcisi (gerçek backend yok, mock interceptor üzerinden cevap dönüyor)
- `go_router` — navigasyon
- `intl` — tarih ve para formatı
- `equatable` — entity karşılaştırmaları
- `easy_localization` — EN–TR metinler (`assets/languages`)

## Mimari

Feature-first bir klasör yapısı kullandım, her feature kendi içinde `data / domain / presentation` olarak ayrılıyor.

Akış kısaca: UI → Riverpod provider → use case → repository → Dio (mock interceptor) → JSON.

UI tarafında `AsyncValue` ile loading / hata / veri dallarını yönetiyorum. Hataları `Failure` tipleriyle toplayıp ekranda gösteriyorum; Dio tarafındaki istisnaları buna map ediyorum.

### Neden Riverpod?

Bloc düşündüm fakat bu ölçekte yani MVP çerçevesinde event/state sınıfları yazmak daha zahmetli ve karmaşık olacağını düşündüm. Riverpod provider'ları `ref.watch` ile kullanmak katmanlar arası bağımlılığı daha temiz ve sade tutuyor.

## Mock ve gerçek API

Şu an her şey `MockInterceptor` ile yerel JSON'dan dönüyor. İleride gerçek bir backend bağlanırsa Dio client'ta mock'u kapatıp base URL'i değiştirmek yeterli olacak şekilde ayırdım. Mock veriyi yapay olarak oluşturdum.

## Dil (EN–TR)

Metinleri `easy_localization` ile İngilizce ve Türkçe tutuyorum. Telefon dili Türkçe değilse uygulama İngilizce açılıyor; Türkçe ise Türkçe. Tarih ve para formatı da seçilen dile göre gidiyor.
