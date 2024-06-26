namespace ConsoleApp3;

public abstract class Employee
{
    public int Id { get; set; }
    public string Name { get; set; }
    public string Phone { get; set; }
    public string Email { get; set; }
    public string Address { get; set; }
    //
    // public virtual void PerformWork()
    // {
    //     Console.WriteLine("Do some work");
    // }

    public abstract void PerformWork();

    public virtual void VirtualMethodDemo()
    {
        Console.WriteLine("This is a virtual method from a base class");
    }
}

public class FullTimeEmployee : Employee
{
    public decimal BiWeeklyPay { get; set; }
    public string Benefits { get; set; }
    
    public override void PerformWork()
    {
        Console.WriteLine("Full time employee works 40 hours");        
    }
}

public sealed class PartTimeEmployee : Employee
{
    public decimal HourlyPay { get; set; }

    public override void PerformWork()
    {
        Console.WriteLine("Part time Employee works 20 hours.");
    }
}

public class Manager : FullTimeEmployee
{
    public decimal ExtraBonus { get; set; }

    public void AttendMeeting()
    {
        Console.WriteLine("Managers haved to attend some meeting");
    }
    
}
