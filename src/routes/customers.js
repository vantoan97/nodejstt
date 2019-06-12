const express = require('express');
const router = express.Router();
//const pool = require('../database');
const helpers = require('../lib/helpers');
const pool = require('../database');
const { isLoggedIn } = require('../lib/auth');

router.get('/add', (req, res) => {
    res.render('customers/add');
});


router.post('/add', async (req, res) => {
    const { customer_details_company, customer_details_project, customer_details_country, customer_details_note } = req.body;
    const newCustomerDetails = {
        customer_details_company,
        customer_details_project,
        customer_details_country,
        customer_details_note,
    };
    const resultCD = await pool.query('INSERT INTO customer_details set ?', [newCustomerDetails]);
    const customer_details_id = resultCD.insertId;
    const { customer_name, customer_email, customer_number_phone, customer_address } = req.body;
    const newCustomer = {
        customer_name,
        customer_email,
        customer_number_phone,
        customer_address,
        customer_details_id,
    };
    const resultC = await pool.query('INSERT INTO customers set ?', [newCustomer]);
    const customer_id = resultC.insertId;
    const user_id = 1;
    const newUserCustomer = {
        user_id,
        customer_id,
    }
    await pool.query('INSERT INTO users_customers set ?', [newUserCustomer]);
    req.flash('success', 'Customer Saved Successfully');
    res.redirect('/customers');
});

// router.get('/', isLoggedIn, async (req, res) => {
//     const customers = await pool.query('SELECT * FROM customers JOIN users_customers ON customers.customer_id = users_customers.customer_id WHERE user_id = ?', [req.user.user_id]);

//     res.render('customers/list', { customers });
// });

router.get('/', async (req, res) => {
    const customers = await pool.query('SELECT * FROM customers');
    res.status(200).send({
        customers: customers
    })
});

router.get('/delete/:customer_id', async (req, res) => {
    const { customer_id } = req.params;
    await pool.query('DELETE FROM users_customers WHERE customer_id = ? and user_id = ?', [customer_id, req.user.user_id]);
    await pool.query('DELETE FROM customers WHERE customer_id = ?', [customer_id]);
    req.flash('success', 'Customer Removed Successfully');
    res.redirect('/customers');
});

router.get('/edit/:customer_id', async (req, res) => {
    const { customer_id } = req.params;
    const customers = await pool.query('SELECT * FROM customers WHERE customer_id = ?', [customer_id]);
    const customerDetails = await pool.query('SELECT * FROM customer_details WHERE customer_details_id = ?', [customers[0].customer_details_id]);

    console.log(customers);
    res.render('customers/edit', { customer: customers[0], customerDetail: customerDetails[0] });
});

router.post('/edit/:customer_id', async (req, res) => {
    const { customer_id } = req.params;
    const { customer_name, customer_email, customer_number_phone, customer_address, customer_details_id } = req.body;
    const newCustomer = {
        customer_name,
        customer_email,
        customer_number_phone,
        customer_address,
        customer_details_id,
    };
    const { customer_details_company, customer_details_project, customer_details_country, customer_details_note } = req.body;
    const newCustomerDetails = {
        customer_details_company,
        customer_details_project,
        customer_details_country,
        customer_details_note,
    };
    await pool.query('UPDATE customer_details set ? WHERE customer_details_id = ?', [newCustomerDetails, newCustomer.customer_details_id]);
    await pool.query('UPDATE customers set ? WHERE customer_id = ?', [newCustomer, customer_id]);
    req.flash('success', 'Customer Updated Successfully');
    res.redirect('/customers');
});

module.exports = router;