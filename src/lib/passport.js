const passport = require('passport');
const LocalStrategy = require('passport-local').Strategy;

const pool = require('../database');
const helpers = require('./helpers');

passport.use('local.signin', new LocalStrategy({
  usernameField: 'user_username',
  passwordField: 'user_password',
  passReqToCallback: true
}, async (req, user_username, user_password, done) => {
  const rows = await pool.query('SELECT * FROM users WHERE user_username = ?', [user_username]);
  if (rows.length > 0) {
    const user1 = rows[0];
    
    const validPassword = await helpers.matchPassword(user_password, user1.user_password)
    if(user1.role_id==1){
      
    }
    if (validPassword) {
      
      done(null,user1, req.flash('success', 'Welcome ' + user1.role_id));
      
    } else {
      done(null, false, req.flash('message', 'Incorrect Password'));
    }
  } else {
    return done(null, false, req.flash('message', 'The Username does not exists.'));
  }

}));

passport.use('local.signup', new LocalStrategy({
  usernameField: 'user_username',
  passwordField: 'user_password',
  passReqToCallback: true
}, async (req, user_username, user_password, done) => {

  const { user_fullname } = req.body;
  let newUser = {
    user_fullname,
    user_username,
    user_password,
    role_id: 1,
    groups_user_id: 1,
  };
  newUser.user_password = await helpers.encryptPassword(user_password);
  // Saving in the Database
  const result = await pool.query('INSERT INTO users SET ? ', newUser);
  newUser.user_id = result.insertId;
  return done(null, newUser);
}));

passport.serializeUser((user1, done) => {
  done(null, user1.user_id);
});

passport.deserializeUser(async (user_id, done) => {
  const rows = await pool.query('SELECT * FROM users WHERE user_id = ?', [user_id]);
  const user = rows[0];
  if(user.role_id==1){
      user.role=1;
  }
  done(null, user);
});