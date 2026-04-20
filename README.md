# Mini Katalog

Flutter ile geliştirilmiş mobil ürün kataloğu uygulaması. Uzak bir API'den ürünleri çekerek kategori filtreleme, arama, ürün detay ve sepet yönetimi sunar.

---

## Özellikler

- **Ürün Listeleme** – `wantapi.com`'dan ürünleri çeker ve 2 sütunlu grid'de gösterir.
- **Kategori Filtresi** – Phone, Computer, Tablet, Watch, Accessory, Smart Home, Vision kategorilerine göre filtreleme.
- **Arama** – Ürün adı veya tagline'a göre anlık arama.
- **Ürün Detayı** – Görsel, açıklama, fiyat ve teknik özellikler içeren detay ekranı.
- **Alışveriş Sepeti** – Ürün ekleme/çıkarma, miktar ayarlama ve toplam fiyat görüntüleme.
- **Sipariş Onayı** – Sipariş özeti içeren basit checkout diyaloğu.

---

## Proje Yapısı

```
mini_katalog2/
├── lib/
│   ├── main.dart                        # Uygulama giriş noktası
│   ├── models/
│   │   ├── product.dart                 # Product modeli
│   │   └── cart.dart                    # Cart ve CartItem modelleri (Singleton)
│   ├── services/
│   │   └── api_service.dart             # wantapi.com'a HTTP istekleri
│   └── screens/
│       ├── home_screen.dart             # Ürün grid, arama, kategoriler, banner
│       ├── product_detail_screen.dart   # Ürün detay ekranı
│       └── cart_screen.dart             # Sepet yönetimi ve checkout
├── assets/
│   └── images/                          # Yerel görsel varlıklar
├── android/
│   └── app/src/main/
│       └── AndroidManifest.xml          # Android manifest (internet izni tanımlı)
└── pubspec.yaml                         # Bağımlılıklar
```

---

## Bağımlılıklar

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.0
```

---

## Kurulum ve Çalıştırma

1. **Flutter Kur** – [flutter.dev](https://flutter.dev/docs/get-started/install)

2. **Paketleri yükle**
   ```bash
   flutter pub get
   ```

3. **Uygulamayı çalıştır**
   ```bash
   flutter run
   ```

> İnternet izni `AndroidManifest.xml` içinde tanımlıdır.

---

## API

Tüm ürün verileri şu adresten çekilir:

```
GET https://wantapi.com/products.php
```

Beklenen yanıt formatı:
```json
{
  "status": "success",
  "data": [
    {
      "id": 1,
      "name": "iPhone 15 Pro",
      "tagline": "...",
      "description": "...",
      "price": "$999",
      "image": "https://...",
      "specs": { "Chip": "A17 Pro", "Storage": "256GB" }
    }
  ]
}
```

---

## Notlar

- Sepet **Singleton pattern** kullanır — oturum boyunca durum korunur.
- Ürün kategorileri ürün adına göre otomatik belirlenir.
- Uygulama **Material 3** ve özel Apple temalı renk şeması kullanır.

---

## Geliştirici

Mobil Programlama dersi proje ödevi olarak geliştirilmiştir.  
Düzce Üniversitesi – Bilgisayar Mühendisliği
