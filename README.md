# Description
a virtual vending machine application which should emulate the goods buying operations and change calculation.

Following are the functional and technical requirements:
	- Allow user to select a product from a provided machine’s inventory;
	-	Allow user to insert coins into a vending machine;
	-	Once the product is selected and the appropriate amount of coins inserted - it should return the product;
	-	It should return change (coins) if inserted too much;
	-	Change should be returned with the minimum amount of coins possible;
	-	It should notify the customer when the selected product is out of stock;
	-	It should return all possible coins from the VM bundles in case it does not have enough change. Coins which were inserted by the user are unavailable to be used for the change.

Initial Input:
The vending machine should be initialized with the following inventory (yet, have in mind the input may vary):

| Product Name | Price   | Quantity |
| ------------ | ------- | -------- |
| Coca Cola    |   2.00  |     2    |
| Sprite       |   2.50  |     2    |
| Fanta        |   2.70  |     3    |
| Orange Juice |   3.00  |     1    |
| Water        |   3.25  |     0    |

The vending machine should be Initialized with the following set of coins in till:

| Value   | Quantity | 
| ------- | -------- |
| 5.00    |     5    |
| 3.00    |     5    |
| 2.00    |     5    |
| 1.00    |     5    |
| 0.50    |     5    |
| 0.25    |     5    |

Attention!
	•	Inserted coins cannot be returned as a change
	•	Change can be returned only from predefined VM coin bundles
	•	Change coins are predefined in table above

## Self test case 1
-----------------------------------------------------------------------
VM is initialized with default following set of coins (see table above)

You want to buy Coca Cola (2$)
You have entered 60.50$ 
On your balance is 58.50$
You press to get the change
And machine will dispense 
5 x 5$ => 25
5 x 3$ => 15
5 x 2$ => 10
5 x 1$ => 5
5 x .5$ => 2.5
4 x .25 => 1

Only 1 x 0.25 is left on VM balance 
-----------------------------------------------------------------------

## Self test case 2
-----------------------------------------------------------------------
VM is initialized with default following set of coins (see table above)

You want to buy Coca Cola (2$)
You have entered 100$ 
On your balance is 98$
You press to get the change
And machine will dispense 
5 x 5$ => 25
5 x 3$ => 15
5 x 2$ => 10
5 x 1$ => 5
5 x 0.5$ => 2.5
5 x 0.25 => 1

VM balance is equal 0$
Your balance is 39.25$
And you can buy something else but without possibility to return change change
-----------------------------------------------------------------------

## Self test case 3
-----------------------------------------------------------------------
After some transactions
there are available only some of coins on VM:
1 x 5$
1 x 3$
5 x 2$
0 x 1$
5 x .5$
5 x .25$
On your balance is 9$

You want to receive the change.
VM returns you:
1 x 5$, 2 x 2$.  (3 coins)

1 x 5$, 1 x 3$, 2 x .5$ is incorrect (4 coins)
1 x 5$, 1 x 3$, 4 x .25$ is incorrect (6 coins)
Etc.
-----------------------------------------------------------------------

## Readme

- Go to project dir: `cd virtual_vending_machine`
- Install gems: `bundle install`
- Run test: `bundle exec rspec spec/`
- Go to lib: `cd virtual_vending_machine/lib`
- Run app: `ruby virtual_vending.rb`