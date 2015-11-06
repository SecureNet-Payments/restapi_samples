// Example of calling SecureNet Charge API using the Java SDK
import SNET.Core.APIContext;
import SecureNetRestApiSDK.Api.Controllers.*;
import SecureNetRestApiSDK.Api.Models.*;
import SecureNetRestApiSDK.Api.Requests.*;
import SecureNetRestApiSDK.Api.Responses.*;

public class SecureNetApiChargeExample {
  public static void main(String[] args) {
    try {
      Address address = new Address();
      address.setCity("Austin");
      address.setCountry("US");
      address.setLine1("123 Main St.");
      address.setState("TX");
      address.setZip("78759");
      
      Card card = new Card();
      card.setAddress(address);
      card.setCvv("123");
      card.setExpirationDate("07/2018");
      card.setNumber("4111111111111111");
      
      ExtendedInformation extendedInfo = new ExtendedInformation();
      extendedInfo.setTypeOfGoods("PHYSICAL");
      
      DeveloperApplication devApp = new DeveloperApplication();
      devApp.setDeveloperId(12345678);
      devApp.setVersion("1.2");
      
      ChargeRequest request = new ChargeRequest();
      request.setCard(card);
      request.setAmount(100d);
      request.setDeveloperApplication(devApp);
      request.setExtendedInformation(extendedInfo);
      APIContext apiContext = new APIContext();
      PaymentsController controller = new PaymentsController();
      ChargeResponse response = (ChargeResponse) controller.processRequest(apiContext, request, ChargeResponse.class);
      
      System.out.println("success: " + response.getSuccess());
      System.out.println("result: " + response.getResult());
      System.out.println("message: " + response.getMessage());
      System.out.println("transactionId: " + response.getTransaction().getTransactionId());
    } catch (Exception ex) {
      System.out.println("Error");
      System.out.println(ex.toString());
    }
  }
}
