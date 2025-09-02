exports.seed = async function(knex) {
  await knex('users').del();
  await knex('users').insert([
    { name: 'Alice Johnson', email: 'alice@example.com' , age: '24' , status: 'Active' },
    { name: 'Bob Smith', email: 'bob@example.com' , age: '32' , status: 'Active' },
    { name: 'Charlie Brown', email: 'charlie@example.com' , age: '54' , status: 'Inactive' },
  ]);
};
