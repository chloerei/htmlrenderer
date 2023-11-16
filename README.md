# README

HTML Renderer is a micro service to render HTML to image/pdf in container.

## Usage

Start service:

```
docker run -p 3000:3000 --cap-add SYS_ADMIN ghcr.io/chloerei/htmlrenderer:master
```

Post a URL to render:

```
curl -X POST -d "url=https://google.com" -o image.png localhost:3000/images
```

or post HTML content:

```
curl -X POST -d "html=<h1>helloworld</h1>" -o image.png localhost:3000/images
```

or use JSON params:

```
curl -X POST -d '{"url":"https://google.com"}' -H "Content-Type: application/json" -o image.png localhost:3000/images
```

## Options

| Name | Description | Default |
| --- | --- | --- |
| url | URL to render | nil |
| html | HTML content to render | nil |
| viewport[width] | View port width | 1280 |
| viewport[height] | View port height | 800 |
| viewport[device_scale_factor] | View port device scale factor | 2 |
| full_page | Whether to render full page | false |
| type | Output type, can be `png` `jpeg` or `webp` | png |
| extra_http_headers | Extra HTTP headers to send to the rendering page. For example: `extra_http_headers[Authorization]=xxx` | nil |

## Access Token

In production, it's recommended to set a access token to protect the service.

```
docker run -p 3000:3000 --cap-add SYS_ADMIN --env ACCESS_TOKEN=<token> httprenderer
```

Then you need to pass the access token in the request header:

```
curl -X POST -d "url=https://google.com" -H "Authorization: Bearer <token>" "localhost:3000/images"
```

## Lang

This service already install Noto CJK fonts. This font has variant languages support. Sometimes your need to set the lang to render the correct font.

When render HTML contet, add `lang` attribute to the `<html>` tag:

```
<html lang="zh-CN">
</html>
```

When render URL, add `Accept-Language` header to the request:

```
curl -X POST -d "url=https://google.com" -H "Accept-Language: zh-CN" -o image.png localhost:3000/images
```

But no all website set `lang` attribute correctly, you can download and modify HTML content before render.
