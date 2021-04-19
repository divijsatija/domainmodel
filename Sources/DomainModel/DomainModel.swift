struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
    var amount: Int
    var currency: String
    
    init(amount: Int, currency: String) {
        self.amount = amount
        self.currency = currency
    }
    
    func convert(_ target: String) -> Money {
        var convertedUSD: Int
        if self.currency == "EUR" {
            convertedUSD = Int(Double(self.amount) / 1.5)
        } else if self.currency == "CAN" {
            convertedUSD = Int(Double(self.amount) / 1.25)
        } else if self.currency == "GBP" {
            convertedUSD = self.amount * 2
        } else {
            convertedUSD = self.amount
        }
        
        if target == "EUR" {
            return Money(amount: Int(Double(convertedUSD) * 1.5), currency: target)
        } else if target == "CAN" {
            return Money(amount: Int(Double(convertedUSD) * 1.25), currency: target)
        } else if target == "GBP" {
            return Money(amount: Int(Double(convertedUSD) * 0.5), currency: target)
        } else {
            return Money(amount: convertedUSD, currency: target)
        }
    }
    
    func add(_ toAdd: Money) -> Money {
        let convertedMoney = convert(toAdd.currency)
        let sumAmount = convertedMoney.amount + toAdd.amount
        return Money(amount: sumAmount, currency: toAdd.currency)
    }
    func subtract(_ toSub: Money) -> Money {
        let convertedMoney = convert(toSub.currency)
        let subAmount = convertedMoney.amount - toSub.amount
        return Money(amount: subAmount, currency: toSub.currency)
    }
}

////////////////////////////////////
// Job
//
public class Job {
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    
    var title: String
    var type: JobType
    
    init(title: String, type: JobType) {
        self.title = title
        self.type = type
    }
    
    func calculateIncome(_ hours: Int) -> Int {
        switch self.type {
        case .Salary(let salary):
            return Int(salary)
        case .Hourly(let hourlyWage):
            return Int(Double(hours) * hourlyWage)
        }
    }
    
    func raise(byAmount: Int) {
        switch self.type {
        case .Salary(let salary):
            self.type = .Salary(UInt(byAmount + Int(salary)))
        case .Hourly(let hourlyWage):
            self.type = .Hourly(Double(byAmount) + hourlyWage)
        }
    }
    
    func raise(byAmount: Double) {
        switch self.type {
        case .Salary(let salary):
            self.type = .Salary(UInt(byAmount + Double(salary)))
        case .Hourly(let hourlyWage):
            self.type = .Hourly(Double(byAmount + hourlyWage))
        }
    }
    
    func raise(byPercent: Double) {
        switch self.type {
        case .Salary(let salary):
            self.type = .Salary(UInt((byPercent + 1.0) * Double(salary)))
        case .Hourly(let hourlyWage):
            self.type = .Hourly(Double((byPercent + 1.0) * hourlyWage))
        }
    }
}

////////////////////////////////////
// Person
//
public class Person {
    var firstName: String
    var lastName: String
    var age: Int
    var job: Job? {
        didSet {
            if age < 16 {
                job = nil
            }
        }
    }
    var spouse: Person? {
        didSet {
            if age < 18 {
                spouse = nil
            }
        }
    }
    
    init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    func toString() -> String {
        return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(String(describing: self.job?.type)) spouse:\(String(describing: self.spouse?.firstName))]"
    }
}

////////////////////////////////////
// Family
//
public class Family {
    var members: [Person] = []
    
    init(spouse1: Person, spouse2: Person) {
        spouse1.spouse = spouse2
        spouse2.spouse = spouse1
        members.append(spouse1)
        members.append(spouse2)
    }
    
    func haveChild(_ child: Person) -> Bool {
        if members[0].age > 21 || members[1].age > 21 {
            members.append(child)
            return true
        }
        return false
    }
    
    func householdIncome() -> Int {
        var completeIncome = 0
        for member in members {
            completeIncome += member.job?.calculateIncome(2000) ?? 0
        }
        return completeIncome
    }
}
