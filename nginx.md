# Nginx

### 文件共享配置
	server {
		client_max_body_size 4G;
		listen 89;
		server_name share;
		root /data/share;
		charset utf-8;
		location / {
			auth_basic "skyline";
        	auth_basic_user_file /etc/nginx/auth_password;
    		autoindex on;
    		autoindex_exact_size on;
    		autoindex_localtime on;
    	}
    }

### Commands
	systemctl start nginx   #启动nginx服务
	nginx -t   #检查nginx配置是否正确
	nginx -s reload   #重新加载配置文件
	htpasswd -b -c /etc/nginx/auth_password skyline 123456
