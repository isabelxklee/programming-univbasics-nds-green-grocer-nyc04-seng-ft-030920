def find_item_by_name_in_collection(name, collection)
  index = 0
  while index < collection.length do 
    if collection[index][:item] == name 
      return collection[index]
    end 
    index += 1
  end 
end

def consolidate_cart(cart)
  new_cart = []
  index = 0 

  while index < cart.length do 
    new_item = find_item_by_name_in_collection(cart[index][:item], new_cart)
    if new_item != nil 
      new_item[:count] += 1
    else 
      new_item = {
        :item => cart[index][:item],
        :price => cart[index][:price],
        :clearance => cart[index][:clearance],
        :count => 1
      }
      new_cart.push(new_item)
    end 
    index += 1
  end 

  new_cart
end

def apply_coupons(cart, coupons)  
    counter = 0 
    while counter < coupons.length do
        cart_name = coupons[counter][:item]
        cart_item = find_item_by_name_in_collection(cart_name, cart)

        coupon_name = "#{cart_name} W/COUPON"
        cart_with_coupon = find_item_by_name_in_collection(coupon_name, cart)

        if cart_item && cart_item[:count] >= coupons[counter][:num]
          if cart_with_coupon
            cart_with_coupon[:coupon] += coupons[counter][:num]
            cart_item[:count] -= coupons[counter[:num]]
          else
            cart_with_coupon = {
              :item => coupon_name,
              :price => coupons[counter][:cost] / coupons[counter][:num],
              :count => coupons[counter][:num],
              :clearance => cart_item[:clearance]
            }
            cart << cart_with_coupon
            cart_item[:count] -= coupons[counter][:num]
          end 
        end 

        counter += 1
    end 
    cart
end

def apply_clearance(cart)
  counter = 0 
  while counter < cart.length do 
    if cart[counter][:clearance]
      cart[counter][:price] = (cart[counter][:price] - (cart[counter][:price] * 0.2)).round(2)
    end 
    counter += 1
  end 
  cart
end 

def checkout(cart, coupon)
  consolidated_cart = consolidate_cart(cart)
  couponed_cart = apply_coupons(consolidated_cart, coupons)
  final_cart = apply_clearance(couponed_cart)

  total = 0 
  counter = 0 

  while counter < final_cart.length do 
    total += final_cart[counter][:price] * final_cart[counter][:count]
    counter += 1
  end 
  
  if total > 100 
    total -= (total * 0.1)
  end 
  
  total 
end 