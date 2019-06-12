const express = require('express');
const router = express.Router();

const pool = require('../database');
const { isLoggedIn } = require('../lib/auth');

router.post('/add', async (req, res) => {
    const { account_bank_number, account_bank_name, account_bank_address, account_bank_swift } = req.body;
    const user_id = 1;
    const newAccountbank = {
        account_bank_number,
        account_bank_name,
        account_bank_address,
        account_bank_swift,
        user_id

    };
    await pool.query('INSERT INTO accounts_bank set ?', [newAccountbank]);
    res.json({
        message: 'Account Bank Saved Successfully',
        newAccountbank
      });
});

router.get('/:user_id', async (req, res) => {
    const {user_id} =req.params;
    const accountsbank = await pool.query('SELECT * FROM accounts_bank');
    res.status(200).send({
        accountsbank: accountsbank
    })
});

router.get('/delete/:account_bank_id', async (req, res) => {
    const { account_bank_id } = req.params;
    await pool.query('DELETE FROM accounts_bank WHERE account_bank_id = ?', [account_bank_id]);
    req.flash('success', 'Account Bank Removed Successfully');
    res.redirect('/accountsbank');
});

router.get('/edit/:account_bank_id', async (req, res) => {
    const { account_bank_id } = req.params;
    const accountsbank = await pool.query('SELECT * FROM accounts_bank WHERE account_bank_id = ?', [account_bank_id]);
    console.log(accountsbank);
    res.render('accountsbank/edit', {accountbank: accountsbank[0]});
});

router.post('/edit/:account_bank_id', async (req, res) => {
    const { account_bank_id } = req.params;
    const { account_bank_number, account_bank_name, account_bank_address, account_bank_swift } = req.body;
    const newAccountbank = {
        account_bank_number,
        account_bank_name,
        account_bank_address,
        account_bank_swift
    };
    await pool.query('UPDATE accounts_bank set ? WHERE account_bank_id = ?', [newAccountbank, account_bank_id]);
    req.flash('success', 'Account Bank Updated Successfully');
    res.redirect('/accountsbank');
});

module.exports = router;