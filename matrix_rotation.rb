# 01 02 03 04 05
# 06 07 08 09 10
# 11 12 13 14 15
# 16 17 18 19 20
# 21 22 23 24 25

# rotated...

# 21 16 11 06 01
# 22 17 12 07 02
# 23 18 13 08 03
# 24 19 14 09 04
# 25 20 15 10 05

# example translations:
# 0,0 => 0,4
# 0,1 => 1,4
# 0,2 => 2,4

# 1,0 => 0,3
# 1,1 => 1,3
# 1,2 => 2,3

# so the old Y position becomes the new X position
# and the new Y position is [number of sides] - [old X]

# m[0][3] is now @matrix[1][0]



class Matrix
  attr_accessor :matrix

  def show_matrix
    rv = ""
    @matrix.each_with_index do |a,i|
      rv += "#{a.join(" ")}\n"
    end
    return rv
  end

  def rotate_90_cw
    m = create_array @sides, false
    @sides.to_i.times do |x|
      @sides.to_i.times do |y|
        m[y][@sides-1-x] = @matrix[x][y]
      end
    end
    @matrix = m
    self
  end

  def rotate_90_cw_no_dupe
    # each time we do a square, we only need to do the "inside" square after that.
    # So we get smaller by 2 each time, I guess?
    (@sides.to_i/2).times do |x|
      (@sides.to_i-(x*2)-1).times do |i|
        y = i + x
        # 01 02 03 04 05
        # 06 07 08 09 10
        # 11 12 13 14 15
        # 16 17 18 19 20
        # 21 22 23 24 25
        #
        # 21 16 11 06 01
        # 22 17 12 07 02
        # 23 18 13 08 03
        # 24 19 14 09 04
        # 25 20 15 10 05
        sv = @matrix[x][y]

        # 0,0 => 4,0 [for x = 0, y = 0+x]
        # and
        # 1,1 => 3,1 [for x = 0, y = 0+x]
        # and
        # 1,2 => 2,1 [for x = 1, y = 1+x]
        @matrix[x][y] = @matrix[@sides-1-y][x]

        @matrix[@sides-1-y][x] = @matrix[@sides-1-x][@sides-1-y]

        @matrix[@sides-1-x][@sides-1-y] = @matrix[y][@sides-1-x]

        @matrix[y][@sides-1-x] = sv
      end
    end
    self
  end

  def create_array sides, fill=true
    m = []
    sides.to_i.times do |i|
      m.push generate_array sides, fill
    end
    m
  end

  def initialize args
    @sides = 1
    @matrix = []
    @iterator = 1


    @sides = args[:sides] if args.include? :sides
    @matrix = create_array @sides, true

  end

  def generate_array sides, fill=true
    a = []
    sides.times do |i|
      if fill
        a.push @iterator.to_s.rjust(2, '0')
        @iterator += 1
      else
        a.push 'xx'
      end
    end
    return a
  end

  def to_s
    return show_matrix
  end

  def matches? matrix
    return false if ! matrix.is_a? Matrix
    m = matrix.matrix

    @matrix.each_with_index do |row, x|
      row.each_with_index do |cell, y|
        if cell != m[x][y]
          return false
        end
      end
    end

    return true
  end
end

sides=100
delta_1 = 0
delta_2 = 0
while sides < 3000 and delta_1 < 5
  puts "\n\nTrying with #{sides} sides.\n"
  m = Matrix.new(:sides => sides)
  # puts m
  t1 = Time.now
  # processing...
  dupe = m.rotate_90_cw
  t2 = Time.now
  delta_1 = t2 - t1
  # puts dupe
  puts "Rotating using a duplicate matrix took #{delta_1}ms"

  m2 = Matrix.new(:sides => sides)
  # puts "\n**************\nNew matrix\n"
  # puts m
  t1 = Time.now
  no_dupe = m2.rotate_90_cw_no_dupe
  t2 = Time.now
  delta_2 = t2 - t1
  # puts no_dupe
  puts "Rotating without the duplicate matrix took #{delta_2}ms"

  # puts "Do they match: #{dupe.matches? no_dupe}"
  sides += 300
end
