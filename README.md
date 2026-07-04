# Andreia & Marco · 05.09.2026 💍

Site de partilha de fotografias do casamento. Os convidados leem um QR code no
dia do casamento, caem numa landing page com o layout do convite e enviam as
fotografias diretamente do telemóvel. Os noivos veem tudo numa área de
administração protegida por login.

## Stack

- **Ruby** 3.4.2 · **Rails** 8.1 · **MySQL** 8
- **Tailwind CSS 4** (paleta creme/eucalipto do convite, fontes Pinyon Script + Cormorant Garamond)
- **Active Storage** (disco local) para as fotografias, com variantes `thumb` (400×400) e `large` (1600px)
- **Delayed Job** para processamento em segundo plano (geração de variantes, purge de ficheiros)
- **rqrcode** para gerar o QR code a imprimir

## Arranque em desenvolvimento

```bash
bin/setup            # bundle + base de dados (usa root/root em 127.0.0.1 por omissão)
bin/rails db:seed    # cria o administrador
bin/dev              # arranca web + tailwind watch + worker do delayed_job
```

Credenciais MySQL configuráveis via `WEDDING_PHOTOS_DATABASE_USERNAME`,
`WEDDING_PHOTOS_DATABASE_PASSWORD` e `WEDDING_PHOTOS_DATABASE_HOST`.

## Páginas

| Rota | Descrição |
|---|---|
| `/` | Landing page dos convidados — upload de várias fotografias com nome opcional |
| `/obrigado` | Confirmação após o envio |
| `/admin/entrar` | Login dos noivos |
| `/admin` | Galeria de todas as fotografias (paginada), com detalhe, download do original e eliminação |
| `/admin/qr` | QR code pronto a imprimir que aponta para a landing page |

## Administrador

O seed cria o administrador com estes valores por omissão (alterar em produção!):

- Email: `marco@andreiaemarco.pt` (ou `ADMIN_EMAIL`)
- Palavra-passe: `AndreiaMarco2026!` (ou `ADMIN_PASSWORD`)

```bash
ADMIN_EMAIL=... ADMIN_PASSWORD=... bin/rails db:seed
```

## Worker do Delayed Job

Em desenvolvimento o `bin/dev` já arranca um worker (`worker: bin/rails jobs:work`).
Em produção:

```bash
RAILS_ENV=production bin/delayed_job start   # requer a gem daemons (já incluída)
```

## Notas para o dia do casamento

- Imprimir o QR code em `/admin/qr` (botão "Imprimir") e colocá-lo nas mesas.
- As fotografias aceitam até 50 MB por ficheiro e apenas conteúdo `image/*`.
- Os originais ficam em `storage/` — fazer backup desta pasta depois da festa!
