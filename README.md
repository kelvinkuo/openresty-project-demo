# openresty-project-demo
## 目录说明
- `./conf` nginx配置文件
- `./lua`  项目的lua源文件
- `./resty_modules` 第三方依赖，用opm安装

## 依赖包安装
```bash
# 在项目根目录下执行
sudo opm --cwd get cdbattags/lua-resty-jwt
```

## 启动
```bash
sudo /usr/local/xzsoft/openresty/nginx/sbin/nginx -p path_to_project
```

