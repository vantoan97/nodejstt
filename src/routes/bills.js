const express = require('express');
const router = express.Router();

const pool = require('../database');
const { isLoggedIn } = require('../lib/auth');
router.get('/list/:customer_id', async (req, res) => {
    const { customer_id } = req.params;
    const customer = await pool.query('SELECT * FROM customers WHERE customer_id = ?', [customer_id]);
    const bill = await pool.query('SELECT * FROM bills JOIN users ON bills.user_id = users.user_id JOIN customers ON bills.customer_id = customers.customer_id JOIN status_bill ON bills.status_bill_id = status_bill.status_bill_id WHERE bills.customer_id = ? AND bills.user_id = ?', [customer_id, req.user.user_id]);
    console.log(bill);
    res.render('bills/list', { bill, customer: customer[0] });
});

router.get('/', isLoggedIn, async (req, res) => {
    const bill = await pool.query('SELECT * FROM bills JOIN users ON bills.user_id = users.user_id JOIN customers ON bills.customer_id = customers.customer_id JOIN status_bill ON bills.status_bill_id = status_bill.status_bill_id WHERE  bills.user_id = ?', [req.user.user_id]);

    res.render('bills/all_list', { bill });
});
router.get('/list',async (req, res) => {
    const bill = await pool.query('SELECT * FROM bills JOIN users ON bills.user_id = users.user_id JOIN customers ON bills.customer_id = customers.customer_id JOIN status_bill ON bills.status_bill_id = status_bill.status_bill_id ');

    res.status(200).send({
        bill: bill
    })
});

router.get('/add', async (req, res) => {
    const accountsbank = await pool.query('SELECT * FROM accounts_bank');
    const allcustomers = await pool.query('SELECT * FROM customers,users_customers WHERE customers.customer_id = users_customers.customer_id and user_id=?', [req.user.user_id]);
    const total = sum(it);
    res.render('bills/addcustomer', { accountsbank , allcustomers, item: it, id: id[0], total: total, id_customer: id_customer[0]});
});
router.post('/add/customer', async (req, res) => {
    const { bill_date, customer_id, bill_monthly_cost } = req.body;
    const newBill = {
        customer_id: Number(id_customer[0].id),
        user_id: req.user.user_id,
        bill_date: bill_date,
        status_bill_id: 1,
        account_bank_id: Number(id[0].id),
        templates_id: 1,
        bills_sum: sum(it),
        bill_monthly_cost: bill_monthly_cost,
    };
    const resultB = await pool.query('INSERT INTO bills set ?', [newBill]);
    const bill_id = resultB.insertId;
    for (i = 0; i < it.length; i++) {
        const newItem = {
            bill_id: bill_id,
            bill_item_description: it[i].bill_item_description,
            bill_item_cost: Number(it[i].cost),
        }
        await pool.query('INSERT INTO bill_items set ?', [newItem]);
    }
    it.length = 0;
    for (i = 0; i < id.length; i++) {
        id.splice(i, 1);
    }
    cus = Number(id_customer[0].id);
    id_customer.length = 0;
    req.flash('success', 'Bill Saved Successfully');
    res.redirect('/bills/list/' + cus);

});
router.get('/selectCustomer/:customer_id', async (req, res) => {
    const { customer_id } = req.params;
    const customers = await pool.query('SELECT * FROM customers WHERE customer_id =?', [customer_id]);
    const cu =  new Object();
    cu.id = customer_id;
    id_customer[0] = cu;
    res.status(200).send({
        customer: customers[0]
    })
});
const it = [];
const id = [];
const id_customer = [];
const it_edit = [];
const id_edit = [];
function sum(arr) {
    var total = 0;
    if (arr.length != 0) {
        for (i = 0; i < arr.length; i++) {
            var c = Number(arr[i].cost);
            total = total + c;
        }

        return total;
    }
    else {
        return 0;

    }
}

function sum_edit(arr) {
    var total = 0;
    if (arr.length != 0) {
        for (i = 0; i < arr.length; i++) {
            var c = Number(arr[i].bill_item_cost);
            total = total + c;
        }

        return total;
    }
    else {
        return 0;

    }
}
router.get('/add/:customer_id', async (req, res) => {
    const { customer_id } = req.params;
    const total = sum(it);
    const customers = await pool.query('SELECT * FROM customers WHERE customer_id = ?', [customer_id]);
    const accountsbank = await pool.query('SELECT * FROM accounts_bank');
    res.render('bills/add', { customer: customers[0], accountsbank, item: it, id: id[0], total: total });
});
router.get('/add/it/:descr/:cost', async (req, res) => {
    const { descr, cost } = req.params;
    const i = new Object();
    i.bill_item_description = descr;
    i.cost = cost;
    it.push(i);
    res.status(200).send({
        items: it
    })
});
router.get('/edit/it/:descr/:cost/:index', async (req, res) => {
    const { descr, cost, index } = req.params;
    const i = new Object();
    i.bill_item_description = descr;
    i.cost = cost;
    it[index] = i;
    res.status(200).send({
        items: it
    })
});
router.get('/delete/it/:index', async (req, res) => {
    const { index } = req.params;
    it.splice(index, 1);

    res.status(200).send({
        items: it
    })
});
router.get('/edit1/:account_bank_id', async (req, res) => {
    const { account_bank_id } = req.params;
    const idd = new Object();
    idd.id = account_bank_id;
    id[0] = idd;
    const accountsbank = await pool.query('SELECT * FROM accounts_bank WHERE account_bank_id = ?', [account_bank_id]);
    console.log(accountsbank);
    res.status(200).send({
        account_bank: accountsbank[0]
    })
});
router.get('/edit/edit1/:account_bank_id', async (req, res) => {
    const { account_bank_id } = req.params;
    const idd = new Object();
    idd.id = account_bank_id;
    id_edit[0] = idd;
    const accountsbank = await pool.query('SELECT * FROM accounts_bank WHERE account_bank_id = ?', [account_bank_id]);
    console.log(accountsbank);
    res.status(200).send({
        account_bank: accountsbank[0]
    })
});
router.post('/add', async (req, res) => {
    const { bill_date, customer_id, bill_monthly_cost } = req.body;
    const newBill = {
        customer_id: Number(customer_id),
        user_id: req.user.user_id,
        bill_date: bill_date,
        status_bill_id: 1,
        account_bank_id: Number(id[0].id),
        templates_id: 1,
        bills_sum: sum(it),
        bill_monthly_cost: bill_monthly_cost,
    };
    const resultB = await pool.query('INSERT INTO bills set ?', [newBill]);
    const bill_id = resultB.insertId;
    for (i = 0; i < it.length; i++) {
        const newItem = {
            bill_id: bill_id,
            bill_item_description: it[i].bill_item_description,
            bill_item_cost: Number(it[i].cost),
        }
        await pool.query('INSERT INTO bill_items set ?', [newItem]);
    }
    it.length = 0;
    for (i = 0; i < id.length; i++) {
        id.splice(i, 1);
    }
    req.flash('success', 'Bill Saved Successfully');
    res.redirect('/bills/list/' + customer_id);

});

router.post('/addBillItem/:bill_id', async (req, res) => {
    const { bill_id } = req.params;
    const { bill_item_description, bill_item_cost } = req.body;
    const newBillItem = {
        bill_id,
        bill_item_description,
        bill_item_cost,
    };
    await pool.query('INSERT INTO bill_items set ?', [newBillItem]);
    const sum = await pool.query('SELECT SUM(bill_item_cost) FROM bills INNER JOIN bill_items ON bills.bill_id = bill_items.bill_id');
    await pool.query('INSERT UPDATE bills set bills_sum = ? WHERE bill_id = ?', [sum, bill_id]);
    req.flash('success', 'Bill Saved Successfully');

});

router.get('/editBillItem/:bill_item_id', async (req, res) => {
    const { bill_item_id } = req.params;
    const billItems = await pool.query('SELECT * FROM bill_items WHERE bill_item_id = ?', [bill_item_id]);
    console.log(billItem);
    res.render('bills/editBillItem', { billItem: billItems[0] });
});

router.post('/editBillItem/:bill_item_id', async (req, res) => {
    const { bill_item_id } = req.params;
    const { bill_item_description, bill_item_cost } = req.body;
    const newBillItem = {
        bill_id,
        bill_item_description,
        bill_item_cost,
    };
    await pool.query('UPDATE bill_items set ? WHERE bill_item_id = ?', [newBillItem, bill_item_id]);
    req.flash('success', 'Bill Updated Successfully');
    res.redirect('/bills');
});

router.get('/deleteItem/:bill_item_id', async (req, res) => {
    const { bill_item_id } = req.params;
    await pool.query('DELETE FROM bill_items WHERE bill_item_id = ?', [bill_item_id]);
    req.flash('success', 'Bill Items Removed Successfully');
    res.redirect('/bills');
});

router.get('/delete/:bill_id', async (req, res) => {
    const { bill_id } = req.params;
    await pool.query('DELETE FROM bill_items WHERE bill_id = ?', [bill_id]);
    await pool.query('DELETE FROM bills WHERE bill_id = ?', [bill_id]);
    req.flash('success', 'Bill Removed Successfully');
    res.redirect('/bills');
});


router.get('/edit/:bill_id', async (req, res) => {
    const { bill_id } = req.params;
    //console.log(bills);
    const items = await pool.query('SELECT * FROM bill_items WHERE bill_id = ?', [bill_id]);
    it_edit.length = 0;
    id_edit.length = 0;
    for (i = 0; i < items.length; i++) {
        it_edit.push(items[i]);
    }
    console.log(it_edit);
    res.redirect('/bills/editk/' + bill_id);
});

router.get('/editk/:bill_id', async (req, res) => {
    const { bill_id } = req.params;
    const bills = await pool.query('SELECT * FROM bills JOIN users ON bills.user_id = users.user_id JOIN customers ON bills.customer_id = customers.customer_id JOIN status_bill ON bills.status_bill_id = status_bill.status_bill_id WHERE bill_id = ?', [bill_id]);
    console.log(bills);
    var aa = 0;
    if (id_edit.length == 0) {
        aa = Number(bills[0].account_bank_id);
    }
    else {
        aa = Number(id_edit[0].id);
    }
    var d = bills[0].bill_date;
    var date = d.getDate();
    var month = d.getMonth() + 1;
    var year = d.getFullYear();
    if (month < 10) month = "0" + month;

    if (date < 10) date = "0" + date;
    bills[0].bill_date = year + "-" + month + "-" + date;
    const accountsbank = await pool.query('SELECT * FROM accounts_bank');
    const total = sum_edit(it_edit);
    res.render('bills/edit', { bill: bills[0], accountsbank, item: it_edit, total: total, ac: aa });
});



router.get('/edit/add/it_edit/:descr/:cost', async (req, res) => {
    const { descr, cost } = req.params;
    const i = new Object();
    i.bill_item_description = descr;
    i.bill_item_cost = cost;
    it_edit.push(i);
    res.status(200).send({
        items: it_edit
    })
});
router.get('/edit/edit/it_edit/:descr/:cost/:index', async (req, res) => {
    const { descr, cost, index } = req.params;
    const i = new Object();
    i.bill_item_description = descr;
    i.bill_item_cost = cost;
    it_edit[index] = i;
    res.status(200).send({
        items: it_edit
    })
});
router.get('/edit/delete/it_edit/:index', async (req, res) => {
    const { index } = req.params;
    it_edit.splice(index, 1);

    res.status(200).send({
        items: it_edit
    })
});

router.post('/editk/:bill_id', async (req, res) => {
    const { bill_id } = req.params;
    
    const { bill_date, customer_id, bill_monthly_cost } = req.body;
    const newBill = {
        customer_id: Number(customer_id),
        user_id: req.user.user_id,
        bill_date: bill_date,
        status_bill_id: 1,
        account_bank_id: Number(id_edit[0].id),
        templates_id: 1,
        bills_sum: sum_edit(it_edit),
        bill_monthly_cost: bill_monthly_cost,
    };
    await pool.query('UPDATE bills set ? WHERE bill_id = ?', [newBill, bill_id]);
    await pool.query('DELETE FROM bill_items WHERE bill_id = ?', [bill_id]);
    for (i = 0; i < it_edit.length; i++) {
        const newItem = {
            bill_id: bill_id,
            bill_item_description: it_edit[i].bill_item_description,
            bill_item_cost: Number(it_edit[i].bill_item_cost),
        }
        await pool.query('INSERT INTO bill_items set ?', [newItem]);
    }
    it_edit.length = 0;
    

    req.flash('success', 'Bill Updated Successfully');
    res.redirect('/bills');
});
module.exports = router;