
# **PAÜ SBE Tez Yazım Kuralları (2025) - Microsoft Word Kaynakça Stili**

Bu proje, **Pamukkale Üniversitesi Sosyal Bilimler Enstitüsü (SBE) 2025 yılı güncel Tez Yazım Kılavuzu**'na uygun olarak hazırlanmış bir Microsoft Word kaynakça stili (`.xsl`) dosyasıdır.

Microsoft Word'ün yerleşik **"Başvurular" (References)** özelliğine bu stili ekleyerek, tez yazım sürecinde atıf ve kaynakçalarınızı otomatik olarak enstitü kurallarına uygun şekilde (Yazar Soyadı, Yıl, Sayfa vb.) oluşturabilirsiniz.


## **Özellikler**


**Metin İçi Atıf:** PAÜ SBE kurallarına uygun (Örn: `Soyadı, 2025: 15`) formatı.

**Çoklu Yazar:** İkiden fazla yazarlı eserlerde otomatik `vd.` kullanımı.

**Kaynakça Düzeni:** 1.25 cm asılı girinti ve alfabetik sıralama (Dosya tarafından otomatik uygulanır).

**Akıllı Ayraçlar:** Dergi makalelerinde cilt/sayı için `:`, sayfa numaraları için `s.` ibaresi.

**Dil Desteği:** Tamamen Türkçe karakter ve terim uyumlu (`ve`, `vd`., `çev.`, `ed.` `vb.`).


## ** Kurulum Talimatları**


Dosyayı kullanabilmek için `PAU_SBE_TYK2025.xsl` dosyasını bilgisayarınızdaki ilgili Microsoft Word dizinine kopyalamanız gerekmektedir.

**Windows İçin Kurulum**

**Yöntem A:**

Bu depodaki `PAU_SBE_TYK2025.xsl` dosyasını bilgisayarınıza indirin.

Dosya Gezgini'ni açın ve adres çubuğuna aşağıdaki yolu yapıştırıp Enter'a basın:

```
%APPDATA%\Microsoft\Bibliography\Style
```


İndirdiğiniz .xsl dosyasını bu klasöre kopyalayın.

**Yöntem B (Program Klasörü):**
Office sürümünüze göre aşağıdaki dizine de kopyalayabilirsiniz:

```
C:\Program Files\Microsoft Office\root\Office16\Bibliography\Style
```

**macOS İçin Kurulum**

`PAU_SBE_TYK2025.xsl` dosyasını indirin.

Uygulamalar klasörüne gidin, **Microsoft Word** uygulamasına sağ tıklayıp **"Paket İçeriğini Göster"**(Show Package Contents) seçeneğini seçin.

Açılan pencerede şu klasör yolunu izleyin:

```Contents / Resources / Style```

İndirdiğiniz dosyayı bu klasörün içine kopyalayın (Sistem şifrenizi isteyebilir).

(Alternatif Yol: Eğer yukarıdaki klasörü bulamazsanız Finder'da "Klasöre Git" diyerek Support/Microsoft/Bibliography/Style dizinine kopyalayabilirsiniz.)

``` 
~/Library/Containers/com.microsoft.Word/Data/Library/Application
``` 


## **Kullanım**


Microsoft Word belgenizi açın.

Üst menüden **Başvurular (References)** sekmesine gelin.

**Stil (Style)** açılır menüsünden **PAÜ SBE Tez Yazım Kuralları** seçeneğini seçin.

Artık "Alıntı Ekle" dediğinizde ve "Kaynakça" oluşturduğunuzda sistem otomatik olarak 2025 kılavuzuna göre biçimlendirme yapacaktır.


**Önemli Notlar**


**Yazar Adları:** Kaynakları Word'e girerken `Ad Soyad` düzenine dikkat ediniz. Stil, soyadını otomatik olarak başa alacak ve adın sadece baş harfini kullanacaktır.

**Sayfa Numaraları:** Metin içi atıflarda sayfa numarasının görünmesi için Word'deki alıntı üzerine tıklayıp "Alıntıyı Düzenle" diyerek sayfa numarasını eklemeniz yeterlidir.


## **📄 Lisans**


Bu proje akademik kullanıma açık ve ücretsizdir. Geliştirilmesine katkıda bulunmak için Pull Request gönderebilirsiniz.


**Hazırlayan:** İhsan Gurur İçirgen


