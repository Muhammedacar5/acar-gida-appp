# Backend veri modeli ve is akis plani

## Roller
- admin: tum urunleri, musterileri, plasiyerleri ve siparisleri yonetir.
- salesperson: kendisine atanmis musterileri ve siparisleri gorur.
- customer: katalogu gorur, sepet olusturur ve siparis verir.

Rol bilgisi istemciden gelen serbest bir alanla belirlenmemeli; guvenilir
sunucu tarafinda atanmis yetki (or. Firebase custom claims) ile dogrulanmalidir.

## Koleksiyonlar
### users/{uid}
- role: customer | salesperson | admin
- fullName
- phone
- businessName
- address
- customerNumber (customer icin benzersiz)
- assignedSalespersonId (customer icin)
- notificationToken (cihaz tokeni; erisim kisitli)

### products/{productId}
- name
- category: Gazlı içecekler | Su ve maden suyu | Meyve suları | Turşu | Kahve | Şeker
- description
- imageUrl
- unitPrice
- wholesalePrice (gerekiyorsa)
- stockQuantity
- isActive
- isFeatured
- unitType: adet | koli | ikisi

### orders/{orderId}
- customerId
- salespersonId
- items: [{productId, nameSnapshot, quantity, unitPriceSnapshot}]
- total
- status: pending | accepted | preparing | dispatched | delivered | cancelled
- createdAt

## Siparis akis
1. Musteri ilk sipariste plasiyer secer.
2. Sunucu secilen plasiyerin aktif ve yetkili oldugunu dogrular.
3. Siparis kaydini olusturur ve customer kaydina plasiyer atamasini yazar.
4. Sonraki siparislerde atanan plasiyer varsayilan gelir; musteri degistirirse sunucu atamayi gunceller.
5. Siparis hem admin panelinde hem secilen plasiyerin panelinde gorunur.
6. Push bildirimi Firebase Cloud Messaging ile ilgili plasiyerin ve yoneticinin cihazlarina gonderilir.

## Bildirim izinleri
Android 13 ve sonrasinda POST_NOTIFICATIONS izni uygulama icinde uygun zamanda istenir.
Izin reddedilirse siparis yine kaydedilir; uygulama ici siparis listesi esas kayit kaynagidir.
Push tokenlari guvenli tutulur ve cikis yapildiginda kullanici-cihaz iliskisi temizlenir.

## Guvenlik
- Kullanici rolunu kendi kendine admin/plasiyer yapamamali.
- Musteri yalnizca kendi profilini ve kendi siparislerini okuyabilmeli.
- Plasiyer yalnizca kendisine atanmis siparisleri okuyabilmeli.
- Admin tum kayitlari yonetebilmeli.
- Fiyat ve toplam tutar istemciden dogrudan guvenilir kabul edilmemeli; sunucu urun fiyatlarindan yeniden hesaplamali.
- Telefon, adres ve isyeri bilgileri kisisel veri oldugundan erisim sinirlandirilmali.
