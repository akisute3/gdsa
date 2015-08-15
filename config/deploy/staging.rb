server 'localhost',
       port: 2222,
       roles: %w{app db web},
       ssh_options: {
         user: 'akisute3',
         keys: %w(/home/akisute/.ssh/id_rsa),
         auth_methods: %w(publickey)
       }
