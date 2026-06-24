# Resend — Налаштування email для КовачМаркет


---

## Архітектура

```
Користувач реєструється
        ↓
  Supabase Auth Hook (send_email)
        ↓
  Edge Function: send-confirmation-email
        ↓
  Resend API → Лист користувачу
```

---

## Крок 1 — Resend акаунт та API ключ

1. Зайдіть на [resend.com](https://resend.com) → **Sign Up**
2. **API Keys** → **Create API Key**
   - Назва: `supabase-smtp`
   - Permission: `Sending access`
3. Скопіюйте ключ — **показується лише один раз**: `re_xxxxxxxxx`

> **Для тесту без домену** використовуйте `from: onboarding@resend.dev` (лист прийде лише на email акаунту Resend).
> **Для продакшну** додайте власний домен: **Domains** → **Add Domain**.

---

## Крок 2 — Секрети Supabase

```bash
# API ключ Resend
supabase secrets set RESEND_API_KEY=re_xxxxxxxxx

# Довільний рядок для верифікації webhook підпису
supabase secrets set SEND_EMAIL_HOOK_SECRET=your-random-secret-here
```

Згенерувати секрет можна командою:
```bash
openssl rand -hex 32
```

---

## Крок 3 — Deploy Edge Function

```bash
supabase functions deploy send-confirmation-email
```

Файл функції: [`supabase/functions/send-confirmation-email/index.ts`](supabase/functions/send-confirmation-email/index.ts)

Що робить функція:
- Отримує Auth Hook webhook від Supabase при реєстрації
- Верифікує підпис запиту (HMAC-SHA256)
- Відправляє брендований HTML email через Resend API

---

## Крок 4 — Auth Hook в Supabase Dashboard

**Authentication → Hooks → Send email**

| Поле | Значення |
|------|----------|
| Hook | Send email |
| URL | `https://<project-ref>.supabase.co/functions/v1/send-confirmation-email` |
| Secret | значення `SEND_EMAIL_HOOK_SECRET` |

> `<project-ref>` — ID проєкту зі сторінки **Project Settings → General**.

---

## Крок 5 — URL Configuration

**Authentication → URL Configuration**

| Поле | Dev | Production |
|------|-----|------------|
| Site URL | `http://localhost:5173` | `https://your-domain.com` |
| Redirect URLs | `http://localhost:5173` | `https://your-domain.com` |

---

## Крок 6 — Замінити `from` адресу

У файлі [`supabase/functions/send-confirmation-email/index.ts`](supabase/functions/send-confirmation-email/index.ts), рядок ~82:

```ts
// До (тест)
from: 'КовачМаркет <onboarding@resend.dev>',

// Після (продакшн з власним доменом)
from: 'КовачМаркет <noreply@your-domain.com>',
```

---

## Перевірка

1. Зареєструйте новий тестовий акаунт
2. Перевірте пошту — має прийти лист від КовачМаркет
3. Натисніть кнопку **«Підтвердити email»** → вас перенаправить на сайт

---

## SMTP (альтернатива без Edge Function)

Якщо не потрібен кастомний шаблон — простіший варіант через SMTP:

**Authentication → Emails → SMTP Settings** → увімкніть **Enable custom SMTP**:

| Поле | Значення |
|------|----------|
| Sender email | `onboarding@resend.dev` |
| Sender name | `КовачМаркет` |
| Host | `smtp.resend.com` |
| Port | `465` |
| Username | `resend` |
| Password | `re_xxxxxxxxx` (API ключ) |
| Minimum interval | `60` |

> Edge Function дає повний контроль над шаблоном; SMTP — швидке рішення за 2 хвилини.
c:\Users\andre\Documents\covaci-build-shop\src\types\database.ts
готово
Read c:\Users\andre\Documents\covaci-build-shop\src\types\database.ts (lines 77-136)
Grep "images" (in c:\Users\andre\Documents\covaci-build-shop\src\types\database.ts)
6 lines of output
Перевірив — images додано і для equipment (рядки 85, 98, 111), і для products (рядки 208, 222, 236). Все коректно.

Крок 3 — AdminDashboard: 4 слоти завантаження фото
Давай розберемось спочатку з товарами (products), потім зробимо те саме для техніки за аналогією.

Read c:\Users\andre\Documents\covaci-build-shop\src\pages\AdminDashboard.tsx (lines 41-130)
Read c:\Users\andre\Documents\covaci-build-shop\src\pages\AdminDashboard.tsx (lines 181-310)
Тепер подивимось, як виглядає форма з ImageUpload для товару, щоб зрозуміти JSX-паттерн.

Read c:\Users\andre\Documents\covaci-build-shop\src\pages\AdminDashboard.tsx (lines 696-740)
Тепер знайдемо аналогічний блок для редагування товару (там теж є ImageUpload), і блоки для техніки.

Grep "ImageUpload" (in c:\Users\andre\Documents\covaci-build-shop\src\pages\AdminDashboard.tsx)
2 lines of output
Grep "ImageUpload|currentImageUrl|onImageUploaded" (in c:\Users\andre\Documents\covaci-build-shop\src\pages\AdminDashboard.tsx)
13 lines of output
Grep "editingProduct\?|editingProduct &&|editingEquipment\?|editingEquipment &&" (in c:\Users\andre\Documents\covaci-build-shop\src\pages\AdminDashboard.tsx)
2 lines of output
Read c:\Users\andre\Documents\covaci-build-shop\src\pages\AdminDashboard.tsx (lines 741-1000)
Подивимось сигнатуру ImageUpload, щоб переконатись як він приймає пропси.

Read c:\Users\andre\Documents\covaci-build-shop\src\components\ImageUpload.tsx
Крок 3 — AdminDashboard: 4 слоти фото
Важливо: зараз ImageUpload показується тільки в формі "Добавить товар/оборудование" — inline-редагування рядків у таблиці (рядки 772 і 1044) взагалі не має полів фото. Це не помилка з мого боку — так влаштований код зараз, тому редагування фото для вже існуючих товарів поки не буде, тільки додавання нових. Якщо потрібно — додамо це окремим кроком пізніше.

3.1. Зміни в newProduct (рядки 52–60)
Заміни:


const [newProduct, setNewProduct] = useState({
  name: "",
  description: "",
  price: 0,
  unit: "",
  stock_quantity: 0,
  category_id: "",
  image_url: "",
});
на:


const [newProduct, setNewProduct] = useState({
  name: "",
  description: "",
  price: 0,
  unit: "",
  stock_quantity: 0,
  category_id: "",
  images: ["", "", "", ""] as string[],
});
Зроби те саме для newEquipment (рядки 61–69) — заміни image_url: "" на images: ["", "", "", ""] as string[].

3.2. handleAddProduct (рядки ~180–210)
В insert([...]) заміни:


image_url: newProduct.image_url,
на:


images: newProduct.images.filter((url) => url !== ""),
image_url: newProduct.images[0] || null,
(image_url лишаємо заповненим обкладинкою — це тимчасова сумісність, доки не зробимо крок 4).

В setNewProduct({...}) (reset форми після додавання, рядки ~201–209) заміни image_url: "" на images: ["", "", "", ""].

Зроби аналогічно для handleAddEquipment (рядки ~252–284): те саме images/image_url в insert, і той самий reset.

3.3. JSX — форма додавання товару (рядки 714–731)
Видали закоментований <input> (рядки 714–720) і заміни блок <div className="col-span-2"><ImageUpload .../></div> (721–731) на:


<div className="col-span-2 grid grid-cols-2 sm:grid-cols-4 gap-2">
  {[0, 1, 2, 3].map((index) => (
    <ImageUpload
      key={index}
      currentImageUrl={newProduct.images[index]}
      onImageUploaded={(url) => {
        const images = [...newProduct.images];
        images[index] = url;
        setNewProduct({ ...newProduct, images });
      }}
      onImageRemoved={() => {
        const images = [...newProduct.images];
        images[index] = "";
        setNewProduct({ ...newProduct, images });
      }}
    />
  ))}
</div>
3.4. JSX — форма додавання техніки (рядки 981–999+)
Зроби той самий заміна: видали закоментований <input> (981–992), заміни <div className="col-span-2"><ImageUpload .../></div> на ідентичний блок з мапом [0,1,2,3], але прив'язаний до newEquipment.images/setNewEquipment.

Дай знати, коли зробиш ці зміни в AdminDashboard.tsx — перейдемо до кроку 4 (відображення images[0] як обкладинки на Products.tsx, Equipment.tsx, Home.tsx, Cart.tsx).

крок 4
Grep "image_url" (in c:\Users\andre\Documents\covaci-build-shop\src\pages\Products.tsx)
2 lines of output
Read c:\Users\andre\Documents\covaci-build-shop\src\pages\Products.tsx (lines 176-200)
Grep "image_url" (in c:\Users\andre\Documents\covaci-build-shop\src\pages\Equipment.tsx)
2 lines of output
Структура в Equipment.tsx ідентична (рядки ~203–205, та сама умова item.image_url ? ... : <span>{item.name.charAt(0)}</span>). Зробимо однакову правку в обох файлах.

Крок 4 — обкладинка картки = images[0]
4.1. Products.tsx (рядки 182–193)
Заміни:


{product.image_url ? (
  <img
    src={product.image_url}
    alt={product.name}
    className="w-full h-full object-cover"
  />
) : (
  <span className="text-gray-400 text-4xl font-bold">
    {product.name.charAt(0)}
  </span>
)}
на:


{product.images?.[0] ? (
  <img
    src={product.images[0]}
    alt={product.name}
    className="w-full h-full object-cover"
  />
) : (
  <span className="text-gray-400 text-4xl font-bold">
    {product.name.charAt(0)}
  </span>
)}
4.2. Equipment.tsx (рядки ~203–213)
Та саме заміна: item.image_url → item.images?.[0], і src={item.image_url} → src={item.images[0]}.

4.3. Чому ?. (optional chaining)
Поки міграцію не запушено з планшета (крок 1 ще в очікуванні), колонки images в реальній БД ще немає — Supabase поверне undefined для цього поля в існуючих записах, і без ?. буде runtime-помилка. ?.[0] безпечно дає undefined, і спрацьовує else-гілка з літерою назви.

4.4. Home.tsx і Cart.tsx
Grep "image_url" (in c:\Users\andre\Documents\covaci-build-shop\src\pages\Home.tsx)
2 lines of output
Read c:\Users\andre\Documents\covaci-build-shop\src\pages\Home.tsx (lines 56-90)
getCategoryImage (рядок 81) стосується категорій — це не торкається товарів/техніки, лишаємо без змін. А getEquipmentImage (рядок 70-71) показує техніку на головній — тут потрібна правка.

4.4. Home.tsx, getEquipmentImage (рядок 71)
Заміни:


if (item.image_url) return item.image_url;
на:


if (item.images?.[0]) return item.images[0];
Read c:\Users\andre\Documents\covaci-build-shop\src\pages\Cart.tsx (lines 176-195)
Grep "products\s*\(|from\(.cart_items.\)|select\(" |select\('" (in c:\Users\andre\Documents\covaci-build-shop\src\pages\Cart.tsx)
5 lines of output
Добре — products (*) (рядок 38) тягне всі поля, тож images автоматично прийде разом з рештою. Заміна потрібна лише в JSX.

4.5. Cart.tsx (рядки 186–194)
Заміни:


{item.products.image_url ? (
  <img
    src={item.products.image_url}
    alt={item.products.name}
    className="w-full h-full object-cover rounded-lg"
  />
) : (
на:


{item.products.images?.[0] ? (
  <img
    src={item.products.images[0]}
    alt={item.products.name}
    className="w-full h-full object-cover rounded-lg"
  />
) : (
Підсумок по кроку 4 — 4 правки:

Products.tsx:183-188 — image_url → images?.[0]
Equipment.tsx:203-208 — те саме
Home.tsx:71 — getEquipmentImage
Cart.tsx:186-191 — item.products.image_url → item.products.images?.[0]
Напиши, коли зробиш — перейдемо до кроку 5 (лайтбокс/каруселька для перегляду всіх 4 фото при кліку на картку).