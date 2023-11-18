# README

HTML Renderer is a micro service to render HTML to image/pdf in container.

> [!WARNING]
> This service can easy eval JavaScript or access locale file in container, it may case security issue. So it should be deploy in a private network and don't expose it to public network. Don't render untrusted URL or HTML content.

## Start service

```
docker run -p 3000:3000 --cap-add SYS_ADMIN ghcr.io/chloerei/htmlrenderer:lastest
```

## API

### /pdf

```
curl -X POST localhost:3000/pdf \
  -H "Content-Type: application/json" \
  -o file.pdf \
  -d '{
    "url": "https://google.com"
  }'
```

All options, see [PdfController::SCHEMA](app/controllers/screenshot_controller.rb) .


### /screenshot

```
curl -X POST localhost:3000/screenshot \
  -H "Content-Type: application/json" \
  -o screenshot.png \
  -d '{
    "url": "https://google.com"
  }'
```

All options, see [ScreenshotController::SCHEMA](app/controllers/screenshot_controller.rb) .

#### Viewport

You can set the viewport size by `width` and `height` options:

```
curl -X POST localhost:3000/screenshot \
  -H "Content-Type: application/json" \
  -o screenshot.png \
  -d '{
    "url": "https://google.com",
    "viewport": {
      "width": 1280,
      "height": 800,
      "device_scale_factor": 2,
    }
  }'
```

Set `device_scale_factor` to 2 for high DPI screen, then the screenshot will be 2560x1600.

## Authentication

In production, it's recommended to set a access token to protect the service.

```
docker run -p 3000:3000 --cap-add SYS_ADMIN --env ACCESS_TOKEN=<token> httprenderer
```

Then you need to pass the access token in the request header:

```
curl -X POST localhost:3000/screenshot \
  -H "Authorization: Bearer <token>" \
  -d '{
    "url": "https://google.com"
  }'
```

## Lang and Font

This service already install Noto CJK fonts. This font has variant languages support. Sometimes your need to set the lang to render the correct font.

When render HTML content, add `lang` attribute to the `<html>` tag:

```
<html lang="zh-CN">
</html>
```

Some site set lang by browser language, you can set the `Accept-Language` header to change the lang:

```
curl -X POST localhost:3000/screenshot \
  -H "Accept-Language: zh-CN" \
  -d '{
    "url": "https://google.com"
  }'
```

You can set the `LANG` environment variable to change the default lang:

```
docker run -p 3000:3000 --cap-add SYS_ADMIN --env LANG=zh_CN ghcr.io/chloerei/htmlrenderer:master
```

Your can install font by build your own image:

```Dockerfile
FROM ghcr.io/chloerei/htmlrenderer:lastest

RUN apt update && apt install -y <font-package>
```

## Development

Clone the repo to local, then run:

```
docker-compose up
```

## License

MIT
