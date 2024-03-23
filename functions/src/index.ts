/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */



import { Firestore } from "firebase-admin/firestore";
import { log } from "firebase-functions/logger";




import { onCall, } from "firebase-functions/v2/https";
import Stripe from "stripe";




const {initializeApp} = require("firebase-admin/app");
const {getFirestore} = require("firebase-admin/firestore");


initializeApp();


const firestore:Firestore = getFirestore();



const stripe = new Stripe(process.env.STRIPE_SECRET_KEY as string);

type AttachPaymentMethodRequestBody= {
    id:string,
    customer: string
};

type CreateCustomerRequestBody = {
    name: string,
    email: string,
    phone:string,
    id:string
};

type CreatePaymentIntentBody = {
    amount: number,
customer:string,
};

export const createStripePaymentIntent = onCall(async(request) => {
    const {amount, customer}:CreatePaymentIntentBody = request.data;
    try {
       
         return await stripe.paymentIntents.create({
            customer,
            amount,
            currency: "usd"
        }).then((value) => value.client_secret);
    } catch (error) {
        log(error);
        return error;
    }
});





export const createStripeCustomer = onCall(async(request) => {
    const {name, email, id, phone}:CreateCustomerRequestBody = request.data;

       try {
        const customer:Stripe.Customer = await stripe.customers.create({
            name,
            email,
            phone,
        });
        await firestore.collection("Users").doc(id).set({"Stripe ID": customer.id});
        return customer;
       } catch (error) {
        return error;
       }
    
    
    // await firestore.collection("Users").doc().update();

});

export const updateStripeCustomer = onCall(async(request) => {
    const {name, email, id, phone}:CreateCustomerRequestBody = request.data;
    await stripe.customers.update(id,{
        name,
        email,
        phone,
        
    });

    // await firestore.collection("Users").doc().update();

});
export const getStripeCustomerDefaultPaymentMethod = onCall(async(request) => {
    const {id} = request.data;
    try {
       return await stripe.customers.retrieve(id);

    } catch (error) {
        return error;
    }

    // await firestore.collection("Users").doc().update();

});

export const setStripeCustomerDefaultPaymentMethod = onCall(async(request) => {
    const {id, payment_method_id} = request.data;
    try {
       return await stripe.customers.update(id, {invoice_settings: {default_payment_method: payment_method_id}});
    } catch (error) {
        return error;
    }

    // await firestore.collection("Users").doc().update();

});

export const deleteStripeCustomer = onCall(async(request) => {
    const {id}:{id:string} = request.data;

    try {
        return await stripe.customers.del(id);


    } catch (error) {
        return error;
    }
});



export const attachStripePaymentMethod = onCall(async(request) => {
    const {customer,id}:AttachPaymentMethodRequestBody = request.data;


    try {

        return stripe.paymentMethods.attach(id, {customer});


    }   catch  (error) {
        return error;

    }
    // console.log(paymentMethod);

    // response.send(paymentMethod);
});

export const updateStripePaymentMethod = onCall(async(request) => {
    const {id}:AttachPaymentMethodRequestBody = request.data;


    try {

        return stripe.paymentMethods.update(id, {card: {
        
        }});


    }   catch  (error) {
        return error;

    }
    // console.log(paymentMethod);

    // response.send(paymentMethod);
});

export const retreiveStripePaymentMethod = onCall(async(request) => {
    const {id} = request.data;


    try {

       return await stripe.customers.listPaymentMethods(id, {
            
        }).then((value) => value.data);


    }   catch  (error:any) {
        log(error);
        return error;

    }
    // console.log(paymentMethod);

    // response.send(paymentMethod);
});


// Start writing functions
// https://firebase.google.com/docs/functions/typescript

// export const helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });


      

