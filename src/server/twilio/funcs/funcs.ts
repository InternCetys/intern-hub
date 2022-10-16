import sgMail from '../sendgrid'

export const sendEmail = (to_email: string) => {
  sgMail
    .send({
      to: to_email,
      from: 'internhub99@gmail.com',
      subject: 'Sending with SendGrid is Fun',
      text: 'and easy to do anywhere, even with Node.js',
      html: '<strong>and easy to do anywhere, even with Node.js</strong>',
    })
    .then(() => {
      console.log('Email sent')
    })
    .catch((error: any) => {
      console.error(error)
    })
}
