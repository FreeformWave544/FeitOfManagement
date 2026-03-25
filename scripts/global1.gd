extends Node



#class counterfeit:
	#var cc_rating: int:
		#set (new):
			#cc_rating = clamp(new, 1, 5)


#RESOURCES

#coins differ from eachother greatly, as such
#i gave genuine coins, goods, and each quality of counterfeits it's own var
var g: int
var c: int
var cc: int
var ccc: int
var goods:int

#amount of distributed counterfeits,if it reaches a certain number, the day is won
var dc: int


#amount of metal_sheet(ms) and blanks
var sheets: int
var blanks: int


#social parameters

var rep:int:
		set (new):
			rep = clamp(new, 1, 5)
#more value to goods

var sus:int:
	set (new):
		sus = clamp(new, 1, 5)
#if sus level reaches 5, you lose, and have to repeat from start
 





 

#ACTIONS

func cutting_sheets():
	sheets -= 10
	blanks += 10




func strike_counterfeit_coins():
	blanks -= 10
	ccc += 10


#emd is the same as spark erosion
func edm_counterfeit_coins():
	blanks -= 20
	cc += 20


func double_counterfeit():
	blanks -= 30
	cc += 10
	c += 20



var new_goods_out:bool = false

func alter_coins():
	g -= 3
	goods += 2

func make_goods():
	sheets -= 1
	goods += 1




#this is the trade func on which all buying and seeling is based
var usedg:
	set (new):
		usedg = clamp(new, 0, g)
var usedc:
	set (new):
		usedc = clamp(new, 0, c)
var usedcc:
	set (new):
		usedcc = clamp(new, 0, cc)
var usedccc:
	set (new):
		usedccc = clamp(new, 0, ccc)

func trade(price,product,amnt,exp):
	var usedg:int
	if price ==  usedg + usedc + usedcc + usedccc:
		g -= usedg
		c -= usedc
		cc -= usedcc
		ccc -= usedccc
		dc += usedc + usedcc + usedccc
		product += amnt
		var risk: int
		risk = ((usedc * 1.5 + usedcc * 1 + usedccc * 0.5) * exp + usedg * -1) / price
		var danger =randi() % price * 2 + 1 
		if danger < risk:
			sus += 1
		
	else:
		pass

func buy_sheets():
	trade(5,sheets,10,1)

func buy_blanks():
	trade(7,blanks,10,1)

func donate():
	trade(50,sus,-1,1)

func sell_goods():
	goods -= 3
	g += 10 + rep
	dc += 5 + rep


#TIME SYSTEM
var actions:Array[Callable] = []
#time of day
var tod:int :
		set (new):
			tod = clamp(new, 0, 8)

var day:int



func day_end():
	pass

func time_passing():
	if tod < 8:
		tod += 1
		for act in actions:
			act.call()
	elif tod == 8:
		day_end()
