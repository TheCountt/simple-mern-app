module.exports = {
  apps : [
    {
    name: "server",
    script: 'index.js',
    instances  : 2,
    exec_mode: "cluster",
    env: {
      NODE_ENV: "development"
    },
    env_production: {
      NODE_ENV: "production"
    }
  },
  // {
  //   name: "client",
  //   script: "client/node_modules/react-scripts/scripts/start.js",
  //   instances  : 1,
  //   exec_mode  : "cluster",
  //   env: {
  //     NODE_ENV: "development",
  //   },
  //   env_production: {
  //     NODE_ENV: "production",
  //   }
  // }
],

  deploy : {
    production : {
      user : 'SSH_USERNAME',
      host : 'SSH_HOSTMACHINE',
      ref  : 'origin/master',
      repo : 'GIT_REPOSITORY',
      path : 'DESTINATION_PATH',
      'pre-deploy-local': '',
      'post-deploy' : 'npm install && pm2 reload ecosystem.config.js --env production',
      'pre-setup': ''
    }
  }
};
