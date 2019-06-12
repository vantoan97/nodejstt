const express = require('express');
const router = express.Router();

const pool = require('../database');
const helpers = require('../lib/helpers');
const { isLoggedIn } = require('../lib/auth');

router.get('/add', (req, res) => {
    res.render('users/add');
});

router.post('/add', async (req, res,) => {
    const { user_fullname, user_username, user_password } = req.body;
    const users1 = await pool.query('SELECT * FROM users where user_username=?', user_username);
   if(users1.length > 0){
   req.flash('message', user_username +'  already exists')
    res.redirect('/users/add');
   }
   else{
    const groups_user_id = req.user.groups_user_id;
    const newUser = {
        user_fullname,
        user_username,
        user_password,
        role_id: 2,
        groups_user_id,
    };
    newUser.user_password = await helpers.encryptPassword(user_password);
    await pool.query('INSERT INTO users set ?', [newUser]);
    req.flash('success', 'Customer Saved Successfully');
    res.redirect('/users');
}
});

router.get('/', isLoggedIn, async (req, res) => {
    if(req.user.role){
    const users = await pool.query('SELECT * FROM users where role_id=2 and groups_user_id=?', [req.user.groups_user_id]);
    var { i } = 1;
    res.render('users/list', { users, i });
    }
    else res.redirect('/');
});

router.get('/delete/:user_id', async (req, res) => {
    if(req.user.role){
    const { user_id } = req.params;
    await pool.query('DELETE FROM users WHERE user_id = ?', [user_id]);
    req.flash('success', 'Users Removed Successfully');
    res.redirect('/users');
    }
    else res.redirect('/');
});

router.get('/edit/:user_id', async (req, res) => {
    if(req.user.role){
    const { user_id } = req.params;
    const users = await pool.query('SELECT * FROM users WHERE user_id = ?', [user_id]);
    //console.log(customers);
    res.render('users/edit', {user: users[0]});
    }
    else res.redirect('/');
});

router.post('/edit/:user_id', async (req, res) => {
    const { user_id } = req.params;
    const { user_fullname , user_password} = req.body;
    const newUser = {
        user_fullname
          
    };
    if(user_password!=""){
   
    newUser.user_password = await helpers.encryptPassword(user_password);
    }


    await pool.query('UPDATE users set ? WHERE user_id = ?', [newUser, user_id]);
    req.flash('success', 'Users Updated Successfully');
    res.redirect('/users');
});

module.exports = router;