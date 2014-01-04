class Date
	@@months = {
		:january => 1,
		:february => 2,
		:march => 3,
		:april => 4,
		:may => 5,
		:june => 6,
		:july => 7,
		:august => 8,
		:september => 9,
		:october => 10,
		:november => 11,
		:december => 12
	}
	@@abbreviations = {
		'jan' => :january,
		'feb' => :february,
		'mar' => :march,
		'apr' => :april,
		'may' => :may,
		'jun' => :june,
		'jul' => :july,
		'aug' => :august,
		'sep' => :september,
		'oct' => :october,
		'nov' => :november,
		'dec' => :december
	}
	def months; return @@months; end
	def monthNames; return @@monthNames; end

	attr_reader :month, :day, :year

	def self.parse(stringDate)
		if stringDate =~ %r{\d{1,2}/\d{1,2}/\d+} then separator = '/'
		elsif stringDate =~ %r{\d{1,2}-\d{1,2}-\d+} then separator = '-'
		end

		if ['/', '-'].include?(separator)
			components = stringDate.split(separator).map{ |component| component.to_i }
			return Date.new(components[0], components[1], components[2])
		else raise "'#{stringDate}' is not a valid format for date parsing"
		end
	end

	def initialize(month, day, year)
		if month.kind_of?(Integer) && !month.to_i.between?(1,12)
			raise "#{month} is not a valid month"
		elsif @@months.has_value?(month.to_i)
			@month = month
		elsif @@months.has_key?(month.downcase.to_sym)
			@month = @@months[month.downcase.to_sym]
		elsif @@abbreviations.has_key?(month.downcase)
			@month = @@months[@@abbreviations[month.downcase].to_sym]
		else raise "#{month} is not a valid month"
		end
		
		if day.kind_of?(Integer) && day.to_i.between?(1,31)
			@day = day.to_i
		else raise"#{day} is not a valid day"
		end
		
		if year.kind_of?(Integer) && year >= 0
			@year = year
		else raise "#{year} is not a valid year"
		end

		if not self.isValidDate?
			raise "#{self.month}/#{self.day}/#{self.year} is not a valid calendar date"
		end
	end

	def isValidDate?
		if [1, 3, 5, 7, 8, 10, 12].include?(self.month)
			if self.day.between?(1,31) then return true; end
		elsif self.month == 2
			if self.day == 29 && self.isLeapYear? then return true
			elsif (not self.isLeapYear?) and self.day.between?(1,28) then return true; end
		elsif [4, 6, 9, 11].include?(self.month)
			if self.day.between?(1,30) then return true; end
		else return false
		end
	end

	def isLeapYear?
		if self.year % 400 == 0 then return true
		elsif self.year % 100 == 0 then return false
		elsif self.year % 4 == 0 then return true
		else return false
		end
	end
end

dates = Array.new
start = Time.now
for i in 0..1000
	dates << Date.parse("1/1/#{2000+i}")
end
finish = Time.now
p finish-start