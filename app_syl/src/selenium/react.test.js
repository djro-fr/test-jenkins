import { Browser, Builder } from 'selenium-webdriver';
import firefox from 'selenium-webdriver/firefox.js';
import assert from 'assert';

describe('Test React App avec Selenium', function() {
  this.timeout(30000);
  let driver;

  before(async function() {
    // Configure le driver (Firefox ici, mais tu peux utiliser Chrome)
    let options = new firefox.Options();
    options.addArguments('--headless'); // Mode sans interface
    let serviceBuilder = new firefox.ServiceBuilder('/usr/bin/geckodriver');

    driver = await new Builder()
      .forBrowser(Browser.FIREFOX)
      .setFirefoxOptions(options)
      .setFirefoxService(serviceBuilder)
      .build();
  });

  after(async function() {
    await driver.quit(); // Ferme le navigateur après les tests
  });

  it('Devrait charger l\'application React et vérifier le titre', async function() {
    // URL application React locale
    await driver.get('http://localhost:5173');

    // Vérifie le titre de la page
    const title = await driver.getTitle();
    console.log('Titre de la page :', title);
    assert.ok(title.includes('React'), 'Le titre devrait contenir "React"');
  });
  
 it('Devrait trouver le bouton et vérifier son texte initial', async function() {
    const button = await driver.findElement({ css: 'button' });
    const initialText = await button.getText();
    assert.strictEqual(initialText, 'count is 0', 'Le bouton devrait afficher "count is 0" au chargement');
  });

  it('Devrait cliquer sur le bouton et vérifier la mise à jour du compteur', async function() {
    const button = await driver.findElement({ css: 'button' });
    await button.click();
    // Attends 500ms pour laisser le temps à React de mettre à jour le DOM
    await driver.sleep(500);
    const updatedText = await button.getText();
    assert.strictEqual(updatedText, 'count is 1', 'Le bouton devrait afficher "count is 1" après un clic');
  });

  it('Devrait vérifier la présence du paragraphe', async function() {
    const paragraph = await driver.findElement({ css: 'p' });
    const paragraphText = await paragraph.getText();
    assert.ok(paragraphText.includes('Edit src/App.jsx'), 'Le paragraphe devrait contenir le texte attendu');
  });
});
