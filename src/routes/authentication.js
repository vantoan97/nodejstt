const express = require('express');
const router = express.Router();
const pool = require('../database');
const helpers = require('../lib/helpers');
const passport = require('passport');
const { isLoggedIn } = require('../lib/auth');

// SIGNUP
router.get('/signup', (req, res) => {
  res.render('auth/signup');
});

router.post('/signup', passport.authenticate('local.signup', {
  successRedirect: '/profile',
  failureRedirect: '/signup',
  failureFlash: true
}));

// SINGIN
/*
router.get('/signin', (req, res) => {
  res.render('auth/signin');
});*/

router.post('/listuser',async (req, res) => {
  const { user_username, user_password} = req.body;
  const rows = await pool.query('SELECT * FROM users WHERE user_username = ?', [user_username]);
  //const user1 = rows[0];
  if (rows.length > 0) {
    const user1 = rows[0];
    const validPassword = await helpers.matchPassword(user_password, user1.user_password)
    if (validPassword) {
      
      res.status(200).send({
        user: true
    });
    }
    else {
      res.status(200).send({
        user: false
    });
    }
  }
  
});


router.post('/signin', (req, res, next) => {
  req.check('user_username', 'Username is Required').notEmpty();
  req.check('user_password', 'Password is Required').notEmpty();
  const errors = req.validationErrors();
  if (errors.length > 0) {
    req.flash('message', errors[0].msg);
    res.redirect('/signin');
  }
  passport.authenticate('local.signin', {
    successRedirect: '/profile',
    failureRedirect: '/signin',
    failureFlash: true
  })(req, res, next);
});




router.get('/logout', (req, res) => {
  req.logOut();
  res.redirect('/');
});

router.get('/profile', isLoggedIn, (req, res) => {
  res.render('profile');
});

module.exports = router;